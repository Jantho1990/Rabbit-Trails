extends Gizmo

export(float) var impulse_force = 800.00

var bodies = []

onready var CollisionArea = $CollisionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	CollisionArea.connect("body_entered", self, "_on_Body_entered")
	CollisionArea.connect("body_entered", self, "_on_Body_exited")
	pass

func _physics_process(delta):
	apply_impulse_to_bodies()
	update()

func _draw():
	var ext = $CollisionArea/CollisionShape2D.shape.extents
	var rec = Rect2(Vector2(0, 0) - Vector2(ext.x / 2, ext.y / 2), ext)
	draw_rect(rec, Color(0.5, 1, 0.5))

func _on_Body_entered(body):
	print('boom')
	bodies.push_back(body)

func _on_Body_exited(body):
	if bodies.has(body):
		var i = bodies.find(body)
		bodies.remove(i)
		print("exit ", body)

func apply_impulse_to_bodies():
	var bodies = CollisionArea.get_overlapping_bodies()
	if bodies.size() > 0:
		for body in bodies:
			if "motion" in body:
#				print("grav before", body.motion)
				body.motion.y = -impulse_force
#				if abs(body.motion.y) > gravity:
#					body.motion = gravity_vec * gravity
#				print("grav after", body.motion)