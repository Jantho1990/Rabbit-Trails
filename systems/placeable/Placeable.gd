extends Node

###
# Dependencies:
# - SelectionManager
# - a parent node
###

# Can entity be placed
export(bool) var allowed_to_place = false

# Can entity be moved
export(bool) var allowed_to_move = false

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	Selection.register_listener('select', self, '_on_Selection')
	Selection.register_listener('deselect', self, '_on_Deselection')
	connect('tree_exiting', self, '_on_Exiting_tree')
	GlobalSignal.listen('move_unit', self, '_on_Move_unit')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func _on_Exiting_tree():
	Selection.unregister_listener('select', self, '_on_Selection')
	Selection.unregister_listener('deselect', self, '_on_Deselection')

func _on_Move_unit():
	print('hit')
	if Selection.selected_entity == parent or Selection.previously_selected_entity == parent:
		print("moving unit")
		allowed_to_move = true

func _on_Selection(selected_unit, previously_selected_unit = null):
	pass

func _on_Deselection(previously_selected_unit):
	allowed_to_move = false