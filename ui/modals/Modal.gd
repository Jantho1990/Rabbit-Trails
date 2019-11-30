extends MarginContainer

var change_menu_func

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_change_menu_func(change_func : Object):
	if change_func is FuncRef:
		change_menu_func = change_func