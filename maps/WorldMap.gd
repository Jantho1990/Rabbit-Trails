extends Node

export(Array, String, FILE, "*.tscn") var maps = []
export(int) var active_map_index = 0
export(bool) var random_start_map = false
export(bool) var auto_link = false

#var exit_portal = preload("res://entities/portals/ExitPortal/ExitPortal.tscn")

var loaded_maps = []
var active_map = null

var world_data = {
	maps = [],
	player = {}
}

var player = null

var exit_portal_map

func _ready():
	load_maps()
	
	if random_start_map:
		print (maps.size())
		active_map_index = math.rand(0, maps.size() - 1)
		print (active_map_index)
	
	if active_map_index_valid():
		set_active_map(loaded_maps[active_map_index])
	else:
		print("Invalid map index: ", active_map_index)
	
	GlobalSignal.dispatch(name + "_loaded", {
		"node": self
	})

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func active_map_index_valid():
	if active_map_index != null \
		and active_map_index >= 0 \
		and active_map_index < maps.size():
			return true
	return false

func load_maps():
	var i = 0 # Sets map index to be used by the portals later
	for map in maps:
		print(map)
		map = load(map)
		map = map.instance()
		map.map_index = i
		loaded_maps.push_back(map)
		i += 1
#		if exit_portal_map == map.map_index:
#			print("Exit portal is on Map ", map.map_index)
#			exit_portal = exit_portal.instance()
#			map.exit_portal = exit_portal
#			map.has_exit_portal = true

func seed_exit_portal_map(number_of_maps):
	exit_portal_map = math.rand(0, number_of_maps - 1)

func set_active_map(map):
	if active_map != null:
		# Turn off error messages because collisions are being monitored.
		# See: https://godotdevelopers.org/forum/discussion/19461/how-do-you-solving-changing-scene-with-collision-is-progress
		for door in active_map.doors:
			door.monitoring = false
#		if active_map.has_node("EnemyContainer"):
#			for enemy in active_map.get_node("EnemyContainer").get_children():
#				enemy.monitoring = false
		remove_child(active_map)
	active_map = map
	add_child(active_map)	
	for door in active_map.doors:
		door.monitoring = true
#	if active_map.has_node("EnemyContainer"):
#		for enemy in active_map.get_node("EnemyContainer").get_children():
#			enemy.monitoring = false

func on_Entity_spawn(data):
	var entity = data.entity