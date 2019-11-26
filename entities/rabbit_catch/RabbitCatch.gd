extends Node2D

onready var CatchArea = $CatchArea
onready var CapturePoint = $CapturePoint

# Called when the node enters the scene tree for the first time.
func _ready():
	CatchArea.connect('body_entered', self, '_on_Body_entered')

func _on_Body_entered(body):
	if body is Rabbit:
		capture_rabbit(body)

func capture_rabbit(rabbit):
	rabbit.freeze()
	var endpoint = CapturePoint.global_position
	var capture_tween = Tween.new()
	capture_tween.interpolate_property(rabbit, 'position', null, endpoint, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	capture_tween.connect('tween_all_completed', self, '_on_Capture_tween_completed', [capture_tween, rabbit])
	add_child(capture_tween)
	capture_tween.start()

func _on_Capture_tween_completed(tween, rabbit):
	remove_child(tween)
	tween.queue_free()
	rabbit.queue_free()
	Rabbits.capture_rabbit()