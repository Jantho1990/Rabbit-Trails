extends Control

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if Selection.has_selection():
				Selection.clear_selection()
		elif event.button_index == BUTTON_RIGHT:
			Selection.clear_selection()