extends Control

# Thanks to https://github.com/godotengine/godot/issues/24699#issuecomment-450838173

var buttons = []
onready var input_row_1 = $MarginContainer/InputRowContainer/InputRow1
onready var input_row_2 = $MarginContainer/InputRowContainer/InputRow2
onready var input_row_3 = $MarginContainer/InputRowContainer/InputRow3

func _ready():
	if not visible:
		deactivate()
	for button in input_row_1.get_children():
		buttons.push_back(button)
	for button in input_row_2.get_children():
		buttons.push_back(button)
	for button in input_row_3.get_children():
		buttons.push_back(button)

func deactivate_tree():
	propagate_call('deactivate', [], false)

func deactivate_buttons():
	for button in buttons:
		button.deactivate_button()

func activate_buttons():
	for button in buttons:
		button.activate_button()

func deactivate():
	hide()
#	deactivate_buttons()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
	print(name, ' deactivated')

func activate_tree():
	propagate_call('activate', [], false)

func activate():
	show()
#	activate_buttons()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
	print(name, ' activated')