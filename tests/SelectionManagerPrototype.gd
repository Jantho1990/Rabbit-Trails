extends Node2D

onready var SelectionManager = get_node("SelectionManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		Selection.clear_selection()