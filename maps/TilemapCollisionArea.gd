extends Area2D

class_name TilemapCollisionArea

func _physics_process(delta):
	update()

func _draw():
	draw_rect(Rect2(Vector2(-25, -50), Vector2(50, 100)), Color(1, 1, 0, 0.25), true)