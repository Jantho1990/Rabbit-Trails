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
onready var placement_area = get_node_or_null('PlacementArea')

# Called when the node enters the scene tree for the first time.
func _ready():
	placement_area.connect('snap_placement', self, '_on_Snap_placement')
	Selection.register_listener('select', self, '_on_Selection')
	Selection.register_listener('deselect', self, '_on_Deselection')
	connect('tree_exiting', self, '_on_Exiting_tree')
	GlobalSignal.listen('move_unit', self, '_on_Move_unit')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if placement_area != null:
		if placement_area.placement_valid:
			allowed_to_place = true
		else:
			allowed_to_place = false

func _on_Exiting_tree():
	Selection.unregister_listener('select', self, '_on_Selection')
	Selection.unregister_listener('deselect', self, '_on_Deselection')

func _on_Move_unit():
	print('hit')
	if Selection.selected_entity == parent: # or Selection.previously_selected_entity == parent:
		print("moving unit")
		allowed_to_move = true

func _on_Selection(selected_unit, previously_selected_unit = null):
	if allowed_to_move:
		breakpoint
		pass

func _on_Deselection(previously_selected_unit):
	print(previously_selected_unit.name, ' was previously selected')
	print('This is ', parent.name, ', and it is ', allowed_to_move, ' that I am allowed to move')
	if previously_selected_unit == parent:
		print(parent.name, " is the previously selected unit")
		if allowed_to_move and not allowed_to_place:
			print("not allowed to place")
			return false
		
		allowed_to_move = false

func _on_Snap_placement(location):
	parent.position = location