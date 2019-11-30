extends MarginContainer

var back_func

onready var options_menu = $CenterContainer/VBoxContainer/OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	options_menu.connect('button_action', self, '_on_Button_action')

func _on_Button_action(action, args = {}):
	match action:
		'back':
			return _on_Back()

func set_back_func(change_func : Object):
	if change_func is FuncRef:
		back_func = change_func

func _on_Back():
	back_func.call_func()