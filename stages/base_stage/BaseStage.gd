extends Node2D

class_name BaseStage

###
# Parent class for all Stages to extend from.
###

onready var tile_map = $TileMap

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