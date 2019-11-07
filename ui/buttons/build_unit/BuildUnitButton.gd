extends Button

export(String) var unit_name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BuildUnitButton_pressed():
	GlobalSignal.dispatch('build_unit', { 'unit_name': unit_name })
