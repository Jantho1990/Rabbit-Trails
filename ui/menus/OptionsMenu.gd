extends VBoxContainer

signal button_action

# Called when the node enters the scene tree for the first time.
func _ready():
	$BackButton.connect('pressed', self, '_on_BackButton_pressed')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BackButton_pressed():
	emit_signal('button_action', 'back')