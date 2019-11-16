extends Node2D

var test_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(test_timer)
	test_timer.one_shot = true
	test_timer.connect('timeout', self, '_on_test_timer')
	test_timer.start(2)

func _on_test_timer():
	GlobalSignal.dispatch('rabbit_hole_activate')