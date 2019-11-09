extends KinematicBody2D

enum placement_types { AIR, GROUND, WALL }
export(placement_types) var placement_type

const UP = Vector2(0, -1)

var placement_valid = false

onready var root = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
#	position = owner.position
	
	update()
#	print("placement area position: ", position)
#	print("mouse speed: ", Input.get_last_mouse_speed())
#	var motion = move_and_slide(Input.get_last_mouse_speed(), UP)
	var motion = move_and_slide(Vector2(0, 0), UP)	
	var slide_count = get_slide_count()
	var collision = false
	for i in get_slide_count():
		collision = get_slide_collision(i)
		if collision:
#			print("Collided with ", collision.collider.name, ', normal ', collision.normal)
			break
#			breakpoint
	
#	if test_move(transform, Input.get_last_mouse_speed()):
#		collision = true
	handle_placement_validation(collision)
	position = owner.position
#	debug_process_collision(collision)

func _draw():
	var placement_color = Color(0, 1, 0, 0.5) if placement_valid else Color(1, 0, 0, 0.5)
	draw_circle(Vector2(0, 0), 50 + 6, placement_color) # +6 = safe_margin

func debug_process_collision(collision):
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

func handle_placement_validation(collision):
	match placement_type:
		placement_types.AIR:
			validate_placement_air(collision)
		placement_types.GROUND:
			validate_placement_ground(collision)
		placement_types.WALL:
			validate_placement_wall(collision)

func validate_placement_air(collision):
	if typeof(collision) == TYPE_BOOL and not collision and \
		not is_on_floor() and not is_on_wall() and not is_on_ceiling():
		placement_valid = true
		print("pos ", position)
		print("owner pos ", owner.position)
	else:
		placement_valid = false

func validate_placement_ground(collision):
	print("validating ground")

func validate_placement_wall(collision):
	print("validating wall")