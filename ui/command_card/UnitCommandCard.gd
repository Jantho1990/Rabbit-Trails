extends Control

# Thanks to https://github.com/godotengine/godot/issues/24699#issuecomment-450838173

func _ready():
	if not visible:
		deactivate()

func deactivate_tree():
	propagate_call('deactivate', [], true)

func deactivate():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
	print(name, ' deactivated')

func activate_tree():
	propagate_call('activate', [], true)

func activate():
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
	print(name, ' activated')