extends Control

class_name StatBarDisplay

onready var label = $Spacing/Label

func set_value(value):
	label.text = String(value)