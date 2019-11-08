extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('unit_command', self, '_on_Unit_command')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Unit_command(data):
	var command_name = data.command_name
	print('got command name: ', command_name)
	
	GlobalSignal.dispatch(command_name)