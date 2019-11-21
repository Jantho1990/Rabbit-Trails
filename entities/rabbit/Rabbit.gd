extends KinematicBody2D

class_name Rabbit

###
# CONSTANTS
###
const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 400
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

# Allows this to be created by generators.
var generator

# The direction
var direction = Vector2(1, 0)

var motion = Vector2(0, 0)

# Jumping
var is_jumping = false

var sight_points
var sight_target

# Hop Timer
var in_air = false
var allowed_to_hop = true
var hop_timer = Timer.new()

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
	hop_timer.connect('timeout', self, '_on_hop_timer_stop')
	hop_timer.one_shot = true
	add_child(hop_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion.y += GRAVITY
#	if not is_on_floor():
#		$Sprite/AnimationPlayer.play('hop_takeoff')
#	else:
#		$Sprite/AnimationPlayer.play('hop_land')
#		$Sprite/AnimationPlayer.animation_set_next('hop_land', 'idle')
#		if allowed_to_hop:
#			start_hop_timer()
	
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
	
#	GlobalSignal.dispatch('debug_label', { 'text': 'Impulse: ' + String(impulse) })	
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
	$Sprite/AnimationPlayer.play('idle')
	if is_on_floor():
		# Apply friction
		motion.x = lerp(motion.x, 0, 0.8)
	if not allowed_to_hop and hop_timer.time_left <= 0:
		start_hop_timer()
		
#	if math.randOneIn(100):
#		state.swap("bound")

func state_jump():
	jump()
	move()

func state_bound():
	move()
#	if not is_on_floor():
#		$Sprite/AnimationPlayer.play('hop_takeoff')
#	else:
#		print('shark')
#		in_air = false
#		$Sprite/AnimationPlayer.play('hop_land')
##		$Sprite/AnimationPlayer.animation_set_next('hop_land', 'idle')
#		state.swap('idle')
##		if allowed_to_hop:
#		start_hop_timer()

###
# OTHER METHODS
###

# Look at what's ahead.
func look():
	sight_points = get_sight_points()
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, sight_points.ahead, [self], collision_mask)
	
	if result:
		if result.collider.name == 'CollisionArea': # This is a gizmo
			var collider_parent = result.collider.get_parent()
			if collider_parent is ScarecrowGizmo:
				turn_around()
		elif result.collider is TileMap:
			turn_around()
#		print("LOOKING AT ", result)
		
#		sight_target = result.collider
#		if result.collider.get_class() == "TileMap" and not is_jumping and is_on_floor():
#			if (position - result.position).x <= JUMP_THRESHOLD_RANGE and state.current != "jump":
#				state.push("jump")
#		elif result.collider.name == "Player" and state.current != "attack":
#			state.add("bound")
#	elif state.current == "bound":
#		state.pop()

func turn_around():
	direction.x = -direction.x
	$Sprite.flip_h = !$Sprite.flip_h

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
#	if not allowed_to_hop and not in_air:
#		print('denied')
#		motion.x = 0
#		return
	if not $Sprite/AnimationPlayer.current_animation == 'hop_takeoff' and not \
		$Sprite/AnimationPlayer.current_animation == 'midair':
		$Sprite/AnimationPlayer.play('hop_takeoff')
		$Sprite/AnimationPlayer.animation_set_next('hop_takeoff', 'midair')
		
	if is_on_floor() and not in_air:
		jump_bump()
	elif is_on_floor():
		allowed_to_hop = false
		in_air = false
		$Sprite/AnimationPlayer.play('hop_land')
		state.swap('idle')
	
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
		in_air = true

func start_hop_timer():
#	allowed_to_hop = false
	hop_timer.start(0.75)

func _on_hop_timer_stop():
	allowed_to_hop = true
	state.swap('bound')