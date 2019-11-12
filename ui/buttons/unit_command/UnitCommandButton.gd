extends Button

export(String) var command_name
export(String, '', 'Q', 'W', 'E', 'A', 'S', 'D', 'Z', 'X', 'C') var command_card_key

onready var command_card = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
