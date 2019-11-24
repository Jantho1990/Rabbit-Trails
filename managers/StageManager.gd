extends Node

###
# Data that will be saved in local state
###
var current_stage = null
var current_stage_name = ''
var current_stage_index = 0
var next_stage_name = ''

export(Array, String, FILE, '*Stage.tscn') var stages = []

var loaded_stages = []

func _init():
	current_stage_index = UserData.get('current_stage_index')

# Called when the node enters the scene tree for the first time.
func _ready():
	if stages.size() > 0:
		for stage in stages:
			var loaded_stage = load(stage).instance()
			loaded_stages.push_back(loaded_stage)
	load_stage(get_stage_at_index(current_stage_index))

func get_stage_at_index(stage_index):
	return loaded_stages[stage_index]

func load_stage(stage):
	current_stage = stage
	current_stage_name = stage.name
	add_child(current_stage)

func unload_current_stage():
	remove_child(current_stage)
	current_stage = null
	current_stage_name = ''