extends Button

export(String) var command_name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Selection.has_selection():
		visible = true
	else:
		visible = false


func _on_BuildUnitButton_pressed():
	GlobalSignal.dispatch('unit_command', { 'command_name': command_name })
