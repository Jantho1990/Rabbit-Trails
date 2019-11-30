extends Node2D

###
# Dependencies:
# - SelectionManager
# - a parent node
###

# Can the entity be dragged right now.
var allowed_to_drag = false

onready var parent = get_parent()

# If Placeable system exists, tie into it.
# I don't like directly tying these together, but I don't
# want to spend too much time trying to be cutely ideal when
# I just need to get the game made.
var placeable

# Called when the node enters the scene tree for the first time.
func _ready():
	if parent.has_node('Placeable'):
		placeable = parent.get_node('Placeable')
		allowed_to_drag = placeable.allowed_to_move

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	GlobalSignal.dispatch('debug_label', { 'text': parent.name +  ' Allowed to drag: ' + String(allowed_to_drag)})
	var parent_allowed_to_drag
	if parent.has_method('allow_drag'):
		parent_allowed_to_drag = parent.allow_drag()
	else:
		parent_allowed_to_drag = true
	
	var allowed_to_move
	if placeable:
		allowed_to_move = placeable.allowed_to_move
	else:
		allowed_to_move = true
	
	if parent_allowed_to_drag and allowed_to_move and allowed_to_drag:
		if not Selection.is_entity_selected(parent):
			allowed_to_drag = false
		else:
			parent.position = get_global_mouse_position()
	else:
		if parent_allowed_to_drag and Selection.is_entity_selected(parent):
			allowed_to_drag = true
