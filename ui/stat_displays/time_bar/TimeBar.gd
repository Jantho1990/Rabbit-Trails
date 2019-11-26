extends HBoxContainer

onready var display = $StatBarDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('stage_time_updated', self, '_on_Stage_time_updated')

func _on_Stage_time_updated(data):
	var time = data.time
	var display_time = String(round(time / 60)).pad_zeros(2) + ':' + String(time % 60).pad_zeros(2)
	display.set_value(display_time)