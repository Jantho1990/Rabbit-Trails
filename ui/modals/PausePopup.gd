extends PopupPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	popup_exclusive = true
	connect('hide', self, '_on_Hide')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed('ui_pause') and not get_tree().paused:
#		breakpoint
		print('PAUSE')
		popup_centered_ratio(1)
#		popup_exclusive = false
		get_tree().paused = true
	elif event.is_action_pressed('ui_cancel'):
		print('UNPAUSE')
		get_tree().paused = false
		emit_signal('hide')

func _on_Hide():
	hide()
	emit_signal('popup_hide')

func _on_Popup_hide():
	print('POPUP HIDE')