extends MarginContainer

var change_menu_func # A funcref explicitly passed in from an external source that can change menus.

onready var pause_menu = $CenterContainer/VBoxContainer/PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.connect('button_action', self, '_on_Button_action')

func _on_Button_action(action, args = {}):
	match action:
		'change_menu':
			return _on_Change_menu(args.menu_name)

func set_change_menu_func(change_func : Object):
	if change_func is FuncRef:
		change_menu_func = change_func

func _on_Change_menu(menu_name):
	change_menu_func.call_func(menu_name)