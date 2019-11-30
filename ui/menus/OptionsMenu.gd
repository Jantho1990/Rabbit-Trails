extends VBoxContainer

signal button_action

onready var fullscreen_button = $Fullscreen/CheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	$BackButton.connect('pressed', self, '_on_BackButton_pressed')
	fullscreen_button.connect('pressed', self, 'toggle_fullscreen')
	fullscreen_button.pressed = OS.window_fullscreen

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BackButton_pressed():
	emit_signal('button_action', 'back')

func toggle_fullscreen():
	OS.window_fullscreen = fullscreen_button.pressed
	emit_signal('button_action', 'fullscreen')