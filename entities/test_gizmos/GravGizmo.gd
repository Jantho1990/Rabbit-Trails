extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_Body_entered")

func _physics_process(delta):
	apply_gravity_to_bodies()
	update()

func _draw():
	draw_circle(Vector2(0, 0), 10, Color(0, 0, 1))
	circle_outline(Vector2(0, 0), 50, Color(0, 1, 0))

func on_Body_entered(body):
	bodies.push_back(body)

func on_Body_exited(body):
	if bodies.has(body):
		var i = bodies.find(body)
		bodies.remove(i)

func apply_gravity_to_bodies():
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		for body in bodies:
			if "motion" in body:
#				print("grav before", body.motion)
				body.motion += gravity_vec * gravity * linear_damp
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