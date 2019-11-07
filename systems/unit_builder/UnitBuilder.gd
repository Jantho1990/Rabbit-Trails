extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('build_unit', self, '_on_Build_unit')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Build_unit(data):
	print('data', data)
#	breakpoint
	var unit_name = data.unit_name
	
	print('Building unit ', unit_name)