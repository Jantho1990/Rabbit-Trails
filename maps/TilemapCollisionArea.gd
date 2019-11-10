extends Area2D

class_name TilemapCollisionArea

func _physics_process(delta):
	update()

func _draw():
	draw_rect(Rect2(Vector2(-16, -16), Vector2(32, 32)), Color(1, 1, 0, 0.25), true)