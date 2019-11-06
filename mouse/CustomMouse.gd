extends Node2D

var sensitivity = 1.0

# Called when the node enters the scene tree for the first time.
func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	position = mouse_position * (Vector2(1, 1) * sensitivity)
#	Input.warp_mouse_position(position) # This will affect the system mouse, be REALLY careful.

func _input(event):
#	if event KEY_ESCAPE
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
