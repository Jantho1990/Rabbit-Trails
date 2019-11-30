extends PopupPanel

var active_menu

onready var options_modal = $MarginContainer/PanelContainer/OptionsModal
onready var pause_modal = $MarginContainer/PanelContainer/PauseModal
onready var modals = $MarginContainer/PanelContainer.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	popup_exclusive = true
	connect('hide', self, '_on_Hide')
	connect_pause_modal()
	options_modal.set_back_func(funcref(self, 'options_back'))
	active_menu = pause_modal

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
		resume_game()

func _on_Hide():
	hide()
	emit_signal('popup_hide')

func _on_Popup_hide():
	print('POPUP HIDE')

func change_menu(menu_name):
	for modal in modals:
		if modal.name == menu_name:
			modal.show()
		else:
			modal.hide()

func resume_game():
	print('UNPAUSE')
	get_tree().paused = false
	emit_signal('hide')

func main_menu():
	# TODO: code for stage management
	
	get_tree().paused = false
	ActiveCameraManager.deactivate_active_camera()
	ActiveCameraManager.remove_all_cameras()
	get_tree().change_scene('res://screens/MainMenuScreen.tscn')

func options_back():
	change_menu('PauseModal')

func connect_pause_modal():
	pause_modal.set_change_menu_func(funcref(self, 'change_menu'))
	pause_modal.set_resume_game_func(funcref(self, 'resume_game'))
	pause_modal.set_main_menu_func(funcref(self, 'main_menu'))