extends Control

class_name StatBarDisplay

onready var label = $Spacing/Label
onready var label_color = label.get('custom_colors/font_color')
onready var label_tween = label.get_node('Tween')

var flash_danger_color = Color(1, 0, 0)
var flash_time = 0.2
var flash_delay = 0.2

func _ready():
	label_tween.connect('tween_all_completed', self, '_on_Flash_completed')	

func set_value(value):
	label.text = String(value)

func flash_danger(times = 1):
	if label_tween.is_active():
		reset_label_tween()
	var start_color = label.get('custom_colors/font_color')
	for i in range(0, times * 2, 2):
		label_tween.interpolate_property(label, 'custom_colors/font_color', start_color, flash_danger_color, flash_time, Tween.TRANS_LINEAR, Tween.EASE_IN, flash_delay * i)
		label_tween.interpolate_property(label, 'custom_colors/font_color', flash_danger_color, start_color, flash_time, Tween.TRANS_LINEAR, Tween.EASE_IN, flash_delay * (i + 1))
	label_tween.start()

func _on_Flash_completed():
	reset_label_tween()

func reset_label_tween():
	label_tween.stop_all()	
	label_tween.remove_all()
	label.set('custom_colors/font_color', label_color)