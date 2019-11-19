extends Gizmo

class_name ThrustGizmo

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var frozen = false

var bodies = []

enum DIRECTIONS {
	RIGHT = 0,
	DOWN = 1,
	LEFT = 2,
	UP = 3
}
export(DIRECTIONS) var direction = DIRECTIONS.RIGHT
export(float) var impulse_force = 800.00
var impulse_direction

#var delay_timer = Timer.new()

onready var CollisionArea = $CollisionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('rotate_unit_left', self, '_on_Rotate_unit_left')
	GlobalSignal.listen('rotate_unit_right', self, '_on_Rotate_unit_right')
	CollisionArea.connect("body_entered", self, "_on_Body_entered")
	CollisionArea.connect("body_exited", self, "_on_Body_exited")
	set_direction()

func _physics_process(delta):
#	apply_gravity_to_bodies()
	update()

func _draw():
	draw_circle(Vector2(0, 0), 20, Color(0, 1, 1))
	circle_outline(Vector2(0, 0), 50, Color(1, 1, 0.5)) # +6 = safe_margin
	_draw_direction()

func _draw_direction():
	draw_line(Vector2(0, 0), impulse_direction * 40, Color(1, 0, 0), 2)
	var arrow_rotation
	match direction:
		DIRECTIONS.RIGHT:
			arrow_rotation = deg2rad(0)
		DIRECTIONS.LEFT:
			arrow_rotation = deg2rad(180)
		DIRECTIONS.DOWN:
			arrow_rotation = deg2rad(90)
		DIRECTIONS.UP:
			arrow_rotation = deg2rad(270)
	var arrow_points = [
		Vector2(40, -5).rotated(arrow_rotation),
		Vector2(40, 5).rotated(arrow_rotation),
		Vector2(45, 0).rotated(arrow_rotation)
	]
	draw_colored_polygon(PoolVector2Array(arrow_points), Color(1, 0, 0))

func _on_Body_entered(body):
#	bodies.push_back(body)
#	GlobalSignal.dispatch('debug_label', { 'text': 'rabies' })
	print('waht')
	if "motion" in body:
		print('MOVE')
#		body.motion += impulse_force * impulse_direction
#		body.add_impulse(impulse_force * impulse_direction)
		bodies.push_back(body)
		var delay_timer = Timer.new()
		delay_timer.one_shot = true
		delay_timer.connect('timeout', self, '_on_Delay_timer_stop', [body, delay_timer])
		delay_timer.start(0.075)
		add_child(delay_timer)

func _on_Body_exited(body):
	if bodies.has(body):
		var i = bodies.find(body)
		bodies.remove(i)

func _on_Rotate_unit_left():
	if Selection.selected_entity == self:
		if direction > 0:
			direction -= 1
		else:
			direction = 3
		set_direction()

func _on_Rotate_unit_right():
	if Selection.selected_entity == self:
		if direction < 3:
			direction += 1
		else:
			direction = 0
		set_direction()

func _on_Delay_timer_stop(body, delay_timer):
	print('FIRE', body, delay_timer)
	body.motion += impulse_force * impulse_direction
	remove_child(delay_timer)

func allow_drag():
	return true

func apply_gravity_to_bodies():
#	var bodies = CollisionArea.get_overlapping_bodies()
	if bodies.size() > 0:
		for body in bodies:
			if "motion" in body:
#				print("grav before", body.motion)
				body.motion += impulse_force * impulse_direction
#				GlobalSignal.dispatch('debug_label', { 'text': body.motion })
#				if abs(body.motion.y) > gravity:
#					body.motion = gravity_vec * gravity
#				print("grav after", body.motion)

func circle_outline(center, radius, color):
	var points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(points + 1):
		var angle_point = deg2rad(0 + i * 360 / points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 1)

func set_direction():
	match direction:
		DIRECTIONS.RIGHT:
			impulse_direction = Vector2(1, 0)
		DIRECTIONS.LEFT:
			impulse_direction = Vector2(-1, 0)
		DIRECTIONS.DOWN:
			impulse_direction = Vector2(0, 1)
		DIRECTIONS.UP:
			impulse_direction = Vector2(0, -1)