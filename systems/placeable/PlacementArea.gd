extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
	var collision = move_and_collide(Input.get_last_mouse_speed() * delta)
	if collision:
		print("collided!")
	else:
		print("nope")