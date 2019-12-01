extends Node2D

onready var CatchArea = $CatchArea
onready var CapturePoint = $CapturePoint
onready var TractorBeamTemplate = $TractorBeam
onready var TractorCircleTemplate = $TractorCircle

# Called when the node enters the scene tree for the first time.
func _ready():
	CatchArea.connect('body_entered', self, '_on_Body_entered')

func _on_Body_entered(body):
	if body is Rabbit:
		capture_rabbit(body)

func capture_rabbit(rabbit):
	rabbit.freeze()
	rabbit.safe_from_death = true
	var endpoint = CapturePoint.global_position
	var capture_tween = Tween.new()
	capture_tween.interpolate_property(rabbit, 'position', null, endpoint, 4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	capture_tween.connect('tween_all_completed', self, '_on_Capture_tween_completed', [capture_tween, rabbit])
	add_child(capture_tween)
	capture_tween.start()
	add_tractor_beam(rabbit)

func add_tractor_beam(target):
	var beam = TractorBeamTemplate.duplicate()
	var circle = TractorCircleTemplate.duplicate()
	var rad = target.direction.x * deg2rad(90)
	var pos = target.global_position + target.get_node('CollisionShape2D').position
	beam.rotation = pos.angle_to(CapturePoint.global_position) + rad
	var rot = beam.rotation
	beam.position = target.get_node('CollisionShape2D').position
	circle.position = target.get_node('CollisionShape2D').position
	target.add_child(beam)
	target.add_child(circle)
	beam.show()
	circle.show()

func _on_Capture_tween_completed(tween, rabbit):
	remove_child(tween)
	tween.queue_free()
	if is_instance_valid(rabbit):
		rabbit.queue_free()
	Rabbits.capture_rabbit()