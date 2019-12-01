extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('restart_stage', self, 'clear_containers')
	GlobalSignal.listen('advance_stage', self, 'clear_containers')

func clear_containers():
	for container in get_children():
		container.clear_children()