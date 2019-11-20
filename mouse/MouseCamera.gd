extends Node2D

var screen_size

var mouse_captured = false
var mouse_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
#	position = get_global_mouse_position()
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var motion
func _input(event):
	pass
	if event is InputEventMouseMotion:
#		position = get_global_mouse_position()
		if mouse_captured:
			position += (event.relative * 2) 
#			breakpoint
#		motion = Input.get_last_mouse_speed()
#		position += motion.normalized() * 45
	if event is InputEventKey:
		if event.is_action_pressed('ui_cancel'):
			if mouse_captured:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_captured = false
			elif not mouse_captured:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				mouse_captured = true
#		breakpoint

func _draw():
	draw_circle(Vector2(0, 0), 3, Color(1, 0, 0))