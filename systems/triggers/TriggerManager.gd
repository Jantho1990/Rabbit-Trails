extends Node

var triggers = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Trigger or child is TimedTrigger:
			triggers[child.trigger_name] = child

func get_trigger(trigger_name):
	if triggers.has(trigger_name):
		return triggers[trigger_name]
	print('No trigger named "', trigger_name, '"')