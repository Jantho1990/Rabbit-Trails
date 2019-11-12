extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mouse_over_ui = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
#	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
#		print("triggered")
#		emit_signal("selection_area_triggered", parent)
	
	if event is InputEventMouseButton and event.pressed and not mouse_over_ui:
		if event.button_index == BUTTON_LEFT:
			if not Selection.has_selection():
#				emit_signal("selection_area_triggered", parent)
				pass
			else:
#				Selection.suppress_selection = true
				Selection.clear_selection()
#				Selection.suppress_selection = false
				print("barf")
		elif event.button_index == BUTTON_RIGHT:
			Selection.clear_selection()

func _on_CommandCard_mouse_entered():
	mouse_over_ui = true

func _on_CommandCard_mouse_exited():
	mouse_over_ui = false
