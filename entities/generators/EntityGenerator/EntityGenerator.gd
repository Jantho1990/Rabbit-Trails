extends Node2D

class_name EntityGenerator

# The entity being spawned.
export(String, FILE, "*.tscn") var Entity = null

# Should the generator be active?
export(bool) var active = true

# How many entities should spawn upon ready?
export(int) var spawn_at_start = 0

# How often should entities spawn?
export(float) var spawn_rate = 30.00

# How many entities should be spawned maximum?
export(int) var maximum_entities = 10

# How often should we increase the maximum number of entities?
export(float) var maximum_increase_rate = 37

# How high should the maximum entities value be allowed to go?
export(int) var maximum_increase_limit = 20

# Should the entity spawn at the generator location?
export(bool) var randomize_spawn = false

# How many entities do we currently have?
var entity_count = 0

# How long has it been since we last spawned an entity?
var entity_spawn_counter = 0

# How long has it been since we last increased the maximum number of entities?
var maximum_entity_increase_counter = 0

# Which container should this generator post events to?
export(String) var target_container_id

# The map which the generator is placed upon.
# This creates a hard dependency where a generator
# must be created as a child of a Map.
onready var map = get_parent()

var map_loaded = false

func _ready():
	#map.connect("map_loaded", self, "on_Map_loaded")
#	GlobalSignal.listen("WorldMap_loaded", self, "on_WorldMap_loaded")
	GlobalSignal.listen("Map_loaded", self, "on_Map_loaded")
	GlobalSignal.listen("entity_dead", self, "on_Entity_dead")
	GlobalSignal.listen(target_container_id + "_children_cleared", self, "on_Children_cleared")
	
	if Entity == null:
		print("Generator " + name + " requires an entity.")
		return
	else:
		Entity = load(Entity)
	print('Generator loaded: ', name)

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if not map_loaded:
		return
	
	if not active:
		return
	
	entity_spawn_counter += delta
	if allowed_to_spawn():
		make_entity()
		entity_spawn_counter -= spawn_rate
	
	# Make the game harder by increasing the maximum over time.
	maximum_entity_increase_counter += delta
	if allowed_to_increase_maximum():
		maximum_entities += 1
		maximum_entity_increase_counter -= maximum_increase_rate

var runct = 0
func on_WorldMap_loaded(data):
	print("run ", runct)
	runct += 1
#	var world_map = data.node

func on_Map_loaded(data):
	map_loaded = true
	if map == null:
		map = data.node
		
	if data.node == map and spawn_at_start > 0:
		# make entities
		for i in spawn_at_start:
			make_entity()

func on_Entity_dead(data):
	var entity = data.entity
	if entity.get("generator") != null and entity.generator == self:
		entity_count -= 1

func make_entity():
	var new_entity = Entity.instance()
	new_entity.generator = self
	
	if not randomize_spawn:
		new_entity.position = self.position
	else:
		map.random_spawn(new_entity)
	
	entity_count += 1
	
	GlobalSignal.dispatch("add_entity", {
		"entity": new_entity,
		"instance": false,
		"container_id": target_container_id
	})

func allowed_to_increase_maximum():
	return maximum_entities < maximum_increase_limit and \
		maximum_entity_increase_counter / maximum_increase_rate > 1

func allowed_to_spawn():
	return entity_count < maximum_increase_limit and \
		entity_count < maximum_entities and \
		entity_spawn_counter / spawn_rate > 1

# Reset counters to zero if the target container's children were cleared.
func on_Children_cleared():
	entity_count = 0
	entity_spawn_counter = 0
	maximum_entity_increase_counter = 0