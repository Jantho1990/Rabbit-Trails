extends VBoxContainer

signal button_action

# Called when the node enters the scene tree for the first time.
func _ready():
	$OptionsButton.connect('pressed', self, '_on_OptionsButton_pressed')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_OptionsButton_pressed():
	emit_signal('button_action', 'change_menu', { 'menu_name': 'OptionsModal' })