extends Gizmo

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bodies = []

onready var CollisionArea = $CollisionArea

# Called when the node enters the scene tree for the first time.
func _ready():
#	connect("body_entered", self, "on_Body_entered")
	pass

func _physics_process(delta):
	apply_impulse_to_bodies()
	update()

func _draw():
	var ext = $CollisionArea/CollisionShape2D.shape.extents
	var rec = Rect2(Vector2(0, 0) - Vector2(ext.x / 2, ext.y / 2), ext)
	draw_rect(rec, Color(0.5, 1, 0.5))

func apply_impulse_to_bodies():
	var bodies = CollisionArea.get_overlapping_bodies()
	if bodies.size() > 0:
		for body in bodies:
			if "motion" in body:
				continue
#				print("grav before", body.motion)
#				body.motion.y = gravity_vec.y * gravity * linear_damp
#				if abs(body.motion.y) > gravity:
#					body.motion = gravity_vec * gravity
#				print("grav after", body.motion)