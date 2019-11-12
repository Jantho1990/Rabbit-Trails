extends Node2D

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	position = get_global_mouse_position()	
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var motion
func _input(event):
	pass
	if event is InputEventMouseMotion:
		position = get_global_mouse_position()
#		motion = Input.get_last_mouse_speed()
#		position += motion.normalized() * 45

func _draw():
	draw_circle(Vector2(0, 0), 3, Color(1, 0, 0))