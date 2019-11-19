extends Gizmo

class_name PlatformGizmo

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	update()

func _draw():
	var ext = $CollisionArea/CollisionShape2D.shape.extents
	var rec = Rect2(Vector2(0, 0) - Vector2(ext.x / 2, ext.y / 2), ext)
	draw_rect(rec, Color(1, 1, 1))