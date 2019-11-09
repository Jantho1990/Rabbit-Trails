extends Node

signal map_loaded

const MINIMUM_SPAWN_DISTANCE = 192

export(int) var min_random_doors = 3
export(int) var max_random_doors = 5

onready var Tilemap = $TileMap
#onready var total_maps = get_parent().maps.size()

###
# Resources
###
#var Door = preload("res://entities/doors/PlaceholderDoor/PlaceholderDoor.tscn")

var map_index
var totem

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	print("loading map...", map_index)
	
	# Randomly spawn the portal locations
	var i = null
	var total_maps = null
	
	# Map is loaded, trigger any code that is waiting on this.
	GlobalSignal.dispatch(name + "_loaded", {
		"node": self
	})

# Get player from parent WorldMap
func get_player_from_parent():
	return get_parent().player

# Return true if entities have the same spawn position.
func have_same_spawn(ent1, ent2):
	return ent1.position == ent2.position

# Spawn an entity in a random tile location on the map.
func random_spawn(entity):
	var valid = false
	var spawn = null
	
	var failct = -1
	while not valid:
		failct += 1
		if failct > 1000:
			print("Fail count exceeded.")
			break
		# Generate a random cell from the map grid
		spawn = Tilemap.random_cell_pos()
		
		# Pass the map's validation first.
		if not spawn_acceptable(Tilemap, spawn):
			valid = false
			continue
		
		# Validate that this random cell is a valid spawn point
		if not entity.has_method("spawn_acceptable"):
			print("ERROR: Cannot random spawn entity without spawn_acceptable method. ", entity)
			return
		elif not entity.spawn_acceptable(Tilemap, spawn):
			valid = false
		else:
			valid = true
	
	# Create the entity
	entity.position = spawn
	if "map_index" in entity:
		entity.map_index = map_index

# Return a random tile from that map.
func random_tile():
	return Tilemap.random_cell()

# Return a random tile location on the map.
func random_tile_pos():
	return Tilemap.random_cell_pos()

# Return true if entity is one of these types.
func is_ignored_entity(entity):
	var name_of_class = entity.get_class()
	if name_of_class.find("Generator") > -1 or \
		name_of_class.find("Container") > -1:
			return true
	return false

# Make sure the map considers a spawn acceptable.
func spawn_acceptable(tilemap, pos):
	for child in get_children():
		if not is_ignored_entity(child) and child.get("position") != null:
			if pos == child.position:
				return false
			elif child.get("_class_name") != null and \
				child._class_name == "Portal" and \
				pos.distance_to(child.position) < MINIMUM_SPAWN_DISTANCE:
					return false
#			else:
#				print("SPAWN DISTANCE ", pos.distance_to(child.position), " ", MINIMUM_SPAWN_DISTANCE, " ", (pos.distance_to(child.position) < MINIMUM_SPAWN_DISTANCE))
	return true