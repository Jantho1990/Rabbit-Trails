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

# Has entity been placed before
var first_placement = true

# Placement is being cancelled
var is_cancelling_placement = false
var old_position = Vector2(0, 0)

onready var parent = get_parent()
onready var placement_area = get_node_or_null('PlacementArea')

# Called when the node enters the scene tree for the first time.
func _ready():
	placement_area.connect('snap_placement', self, '_on_Snap_placement')
	Selection.register_listener('select', self, '_on_Selection')
	Selection.register_listener('deselect', self, '_on_Deselection')
	connect('tree_exiting', self, '_on_Exiting_tree')
	GlobalSignal.listen('move_unit', self, '_on_Move_unit')
	GlobalSignal.listen('cancel_placement', self, '_on_Cancel_placement')

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
		old_position = parent.position

func _on_Selection(selected_unit, previously_selected_unit = null):
	if allowed_to_move:
		breakpoint
		pass

func _on_Deselection(previously_selected_unit):
	print(previously_selected_unit.name, ' was previously selected')
	print('This is ', parent.name, ', and it is ', allowed_to_move, ' that I am allowed to move and ', is_cancelling_placement, ' that I am cancelling my placement.')
	if previously_selected_unit == parent:
		print(parent.name, " is the previously selected unit")
		
		if not is_cancelling_placement:
			if allowed_to_move and not allowed_to_place:
				print("not allowed to place")
				return false
			
			allowed_to_move = false
			
			if first_placement:
				Budget.subtract(parent.budget_cost)
				first_placement = false
				GlobalSignal.dispatch('unit_placed', { 'unit': parent })
		else:
			if allowed_to_move:
				if first_placement:
					var signal_name = 'remove_' + helpers.get_node_original_name(previously_selected_unit)
					GlobalSignal.dispatch(signal_name, { 'entity': previously_selected_unit })
				else:
					allowed_to_move = false
					parent.position = old_position # Move it back to where it was.

func _on_Snap_placement(location):
#	GlobalSignal.dispatch('debug_label', { 'text': 'Snap: ' +  String(location) })
	var collision_shape = placement_area.get_node('CollisionShape2D').shape
	var offset = Vector2(0, collision_shape.extents.y / 2)
	parent.position = location - (offset)

func _on_Cancel_placement():
	if Selection.is_entity_selected(parent):
		cancel_placement()

func cancel_placement():
	is_cancelling_placement = true
	Selection.clear_selection()