extends MarginContainer

var change_menu_func # A funcref explicitly passed in from an external source that can change menus.
var resume_game_func
var main_menu_func

onready var pause_menu = $CenterContainer/VBoxContainer/PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.connect('button_action', self, '_on_Button_action')

func _on_Button_action(action, args = {}):
	match action:
		'change_menu':
			return _on_Change_menu(args.menu_name)
		'resume_game':
			return _on_Resume_game()
		'main_menu':
			return _on_Main_menu()

func set_change_menu_func(change_func : Object):
	if change_func is FuncRef:
		change_menu_func = change_func

func set_resume_game_func(change_func: Object):
	if change_func is FuncRef:
		resume_game_func = change_func

func set_main_menu_func(change_func: Object):
	if change_func is FuncRef:
		main_menu_func = change_func

func _on_Change_menu(menu_name):
	change_menu_func.call_func(menu_name)

func _on_Resume_game():
	resume_game_func.call_func()

func _on_Main_menu():
	main_menu_func.call_func()