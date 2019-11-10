extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
#	draw_circle(Vector2(0, 0), 10, Color(1, 0, 1))
#	circle_outline(Vector2(0, 0), 50, Color(1, 1, 0))
#	draw_rect(Rect2(Vector2(1, 0), Vector2(50, 100)), Color(1, 0, 1), false)
	draw_rect(Rect2(Vector2(-25, -50), Vector2(50, 100)), Color(1, 0, 1), false)