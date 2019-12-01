extends Node2D

class_name BaseStage

export(int) var passing_score = 10000
export(int) var starting_budget = 5000

###
# Parent class for all Stages to extend from.
###

onready var tile_map = $TileMap
onready var StageManager = get_parent()
onready var cinematics = $Cinematics
onready var triggers = $Triggers

func _ready():
	GlobalSignal.dispatch('active_camera_resize_bounds', {
		'bounds': {
			'top': tile_map.dimensions.y,
			'bottom': tile_map.dimensions.y + tile_map.dimensions.height,
			'left': tile_map.dimensions.x,
			'right': tile_map.dimensions.x + tile_map.dimensions.width
		},
		'all_cameras': true
	})
	# Map_loaded is bad naming convention, but using it until I can refactor EntityGenerator
	GlobalSignal.dispatch("Map_loaded", {
		"node": self
	})