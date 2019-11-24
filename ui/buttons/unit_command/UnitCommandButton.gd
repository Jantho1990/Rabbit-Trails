extends TextureButton

class_name UnitCommandButton

export(String) var command_name
export(String, '', 'Q', 'W', 'E', 'A', 'S', 'D', 'Z', 'X', 'C') var command_card_key

onready var command_card = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	connect('pressed', self, '_on_UnitCommandButton_pressed')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Selection.has_selection():
#		visible = true
#	else:
#		visible = false

func _input(event):
	if event is InputEventKey and \
		event.is_action('command_card_key'):
			if char(event.scancode) == command_card_key:
				GlobalSignal.dispatch('unit_command', { 'command_name': command_name })
			else:
				print('1: ', char(event.scancode), ', 2:', command_card_key)

func _on_UnitCommandButton_pressed():
	GlobalSignal.dispatch('unit_command', { 'command_name': command_name })

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