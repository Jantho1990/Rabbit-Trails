extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const UP = Vector2(0, -1)

onready var root = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	position = owner.position
#	print("placement area position: ", position)
	var motion = move_and_slide(Input.get_last_mouse_speed(), UP)
	var slide_count = get_slide_count()
	var collision = false
	for i in get_slide_count():
		var collider = get_slide_collision(i)
		if collider:
			collision = true
			print("Collided with ", collider.collider.name)
	
	if collision:
#		print("collided!")
		if is_on_floor():
			print("is on floor")
		elif is_on_wall():
			print("is on wall")
		elif is_on_ceiling():
			print("is on ceiling")
		else:
			print("collision")
	else:
		print("nope")