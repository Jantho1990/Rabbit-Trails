extends Node

###
# Data that will be saved in local state
###
var current_stage = ''
var next_stage = ''

export(Array, String, FILE, '*Stage.tscn') var stages = []

var loaded_stages = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if stages.size() > 0:
		for stage in stages:
			var loaded_stage = load(stage).instance()
			loaded_stages.push_back(stage)

func load_stage(stage):
	current_stage = stage.name
	add_child(stage)

func unload_current_stage():
	current_stage = ''
	remove_child(current_stage)