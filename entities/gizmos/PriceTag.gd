extends Label

onready var tween = Tween.new()
var tween_time = 0.2

func _ready():
	add_child(tween)
	tween.interpolate_property(self, 'rect_position', rect_position, Vector2(rect_position.x, rect_position.y - 100), tween_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(self, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), tween_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)

func dismiss():
	print('GET OUTTA HERE')
	if tween.is_active():
		tween.stop_all()
	tween.start()