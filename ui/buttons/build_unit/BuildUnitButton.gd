extends TextureButton

export(String) var unit_name
export(String, 'Q', 'W', 'E', 'A', 'S', 'D', 'Z', 'X', 'C') var command_card_key

onready var command_card = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventKey and \
		event.is_action('command_card_key') and \
			char(event.scancode) == command_card_key:
				GlobalSignal.dispatch('build_unit', { 'unit_name': unit_name })

func _on_BuildUnitButton_pressed():
	GlobalSignal.dispatch('build_unit', { 'unit_name': unit_name })

func deactivate_button():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
	print(name, ' deactivated')

func activate_button():
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
	print(name, ' activated')