extends Node

###
# Dependencies:
# - SelectionManager
# - a parent node
###

# Can the entity be dragged right now.
var allowed_to_drag = false

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if allowed_to_drag:
		if not Selection.is_entity_selected(parent):
			allowed_to_drag = false
		else:
			parent.position = get_viewport().get_mouse_position()
	else:
		if Selection.is_entity_selected(parent):
			allowed_to_drag = true
