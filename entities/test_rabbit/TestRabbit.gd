extends KinematicBody2D

###
# CONSTANTS
###
const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -550
const JUMP_FORGIVENESS = 0.08
const SIGHT_RANGE = 100
const JUMP_THRESHOLD_RANGE = (SIGHT_RANGE / 2) + 10
const ATTACK_RANGE = 40
const MELEE_RANGE = 50
const MELEE_DAMAGE = 20

###
# CONFIGURABLE PROPERTIES
###

# Walk speed.
export(float) var walk_speed = 100.00

# Jump bump
export(float) var jump_bump_height = 400.00

###
# PROPERTIES
###

# The direction
var direction = Vector2(1, 0)

var motion = Vector2(0, 0)

# Jumping
var is_jumping = false

var sight_points
var sight_target

###
# ONREADY PROPERTIES
###

onready var state = $State

###
# METHODS
###

# Called when the node enters the scene tree for the first time.
func _ready():
	$MovementHandler.set_defaults({
		"down": funcref(self, "move_down"),
		"idle": funcref(self, "move_idle"),
		"left": funcref(self, "move_left"),
		"right": funcref(self, "move_right"),
		"up": funcref(self, "move_up")
	})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion.y += GRAVITY
	if is_on_floor():
		print("ON FLOOR")
		print("state is", state.current)
		print(global.run_time)
	
	if state.current == "jump" and is_on_floor():
		is_jumping = false
		state.pop()
	
	look()
	
	match state.current:
		"idle":
			state_idle()
		"jump":
			state_jump()
		"bound":
			state_bound()
		_:
			print("No state defined.", state.current)
			pass
	
	motion = move_and_slide(motion, UP)
#	print('bunny', motion)

###
# MOVEMENT METHODS
###

func move_down():
	pass
	
func move_idle():
	pass

func move_left():
	motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
#	$Sprite.scale.x = 1
	direction.x = -1
#	playAnim('run', -1, 1.6)

func move_right():
	motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
#	$Sprite.scale.x = -1
	direction.x = 1
#	playAnim('run', -1, 1.6)

func move_up():
#	motion.y = JUMP_HEIGHT
#	jump()
	pass

###
# STATE METHODS
###

func state_idle():
	motion.x = 0
	if math.randOneIn(100):
		state.swap("bound")

func state_jump():
	jump()
	move()

func state_bound():
	move()

###
# OTHER METHODS
###

# Look at what's ahead.
func look():
	sight_points = get_sight_points()
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, sight_points.ahead, [self], collision_mask)
	
	if result:
#		print("LOOKING AT ", result)
		sight_target = result.collider
		if result.collider.get_class() == "TileMap" and not is_jumping and is_on_floor():
			if (position - result.position).x <= JUMP_THRESHOLD_RANGE and state.current != "jump":
				state.push("jump")
		elif result.collider.name == "Player" and state.current != "attack":
			state.add("bound")
#	elif state.current == "bound":
#		state.pop()

# The point at farthest looking range.
func get_sight_points():
	return {
		"ahead": position + (Vector2(SIGHT_RANGE, 0) * direction),
		"above": position + (Vector2(JUMP_THRESHOLD_RANGE, 0) * direction) + Vector2(0, JUMP_HEIGHT)
	}

# Jump
func jump():
	if not is_jumping:
		is_jumping = true
		motion.y = JUMP_HEIGHT
		

# Initiate movement.
func move():
	if is_on_floor():
		jump_bump()
	match int(direction.x):
		-1:
			$MovementHandler.move("left")
		1:
			$MovementHandler.move("right")
		_:
			print("No direction ", direction)
			print(typeof(direction.x))

func jump_bump(): # Add a slight bump, used for phone movement.
	if is_on_floor():
		motion.y -= jump_bump_height