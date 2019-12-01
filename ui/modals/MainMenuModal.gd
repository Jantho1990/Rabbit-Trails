extends VBoxContainer

var change_menu_func # A funcref explicitly passed in from an external source that can change menus.

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewGameButton.connect('pressed', self, '_on_NewGameButton_pressed')
	$OptionsButton.connect('pressed', self, '_on_OptionsButton_pressed')
	$ExitButton.connect('pressed', self, '_on_ExitButton_pressed')
	
	if not UserData.has('has_current_game') or UserData.get('has_current_game') == false:
		$ContinueButton.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_NewGameButton_pressed():
#	breakpoint
	UserData.set('has_current_game', true)
	UserData.set('current_stage_name', 'TutorialStage')
	get_tree().change_scene('res://screens/GameScreen.tscn')

func _on_OptionsButton_pressed():
	if change_menu_func:
		change_menu_func.call_func('OptionsModal')

func _on_ExitButton_pressed():
	get_tree().quit()

func set_change_menu_func(change_func : Object):
	if change_func is FuncRef:
		change_menu_func = change_func