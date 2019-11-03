extends Node

signal select_unit
signal deselect_unit

# Names of entities which should be selectable
export(Array, String) var selectable_entities = []

# The currently selected unit
var selected_entity = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Deselect_entity():
	deselect_entity(selected_entity)

# Select a entity
func select_entity(entity = null):
	emit_signal("deselect_entity")
	
	if not entity == null:
		selected_entity = entity
		connect("deselect_entity", self, "_on_Deselect_entity")

func deselect_entity(entity):
	disconnect("deselect_entity", entity, "_on_Deselect_entity")
	selected_entity = null

# Add the selection node as a child of the selected entity.
func add_selection_node(entity):
	# Only entities with a SelectionArea node are allowed to be selected.
	if not entity.has_node("SelectionArea"):
		return false
	
	entity.add_child(SelectionNode.new())

# Remove the selection node from the children of the selected entity.
func remove_selection_node(entity):
	if has_selection_node(entity):
		var selection_node = entity.find_node("SelectionNode")
		selection_node.queue_free()

# Determine if entity has a selection node.
func has_selection_node(entity):
	return entity.find_node("SelectionNode") != null

# Determine if entity is selected.
func is_entity_selected(entity):
	return has_selection_node(entity)

# Determine if unit is selectable.
func is_entity_selectable(entity):
	return selectable_entities.has(entity.name)

# Determine if an input position is within selection area.
func is_pos_in_entity_selection(entity, pos):
	var selection_node = entity.get_node("SelectionNode")
	

###
# Selection Node
# The presence of this node signifies its parent is a selected entity.
# This allows for creating entity selection without having to create
# special properties on an entity, making the SelectionManager a
# standalone system.
###
class SelectionNode extends Node2D:
	var selection_area
	var selected = false
	onready var entity = get_parent()
	
	func _ready():
		# Get the selection area on the entity.
		selection_area = entity.get_node("SelectionArea")

	func _draw():
		draw.circle_outline(entity.position, 50, Color(255, 0, 0))
	
	func _on_Unit_selected():
		selected = !selected
	
	func is_pos_in_selection_area(pos):
		return 

###
# SelectionArea
# This node allows entities to implement custom selection areas.
###
class SelectionArea extends Area2D:
	var entity = get_parent()
	export(float) var width = 0
	export(float) var height = 0