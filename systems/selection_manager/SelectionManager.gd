extends Node

signal select_entity
signal deselect_entity

# Names of entities which should be selectable
export(Array, String) var selectable_entities = []

# The currently selected unit
var selected_entity = null

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("deselect_entity", self, "_on_Deselect_entity")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if not event is InputEventMouseButton:
		return
		
	if event.pressed:
		pass

func _on_Deselect_entity():
	deselect_entity(selected_entity)

func register_entity(entity):
	var selection_area = entity.get_node("SelectionArea")
	selection_area.register_entity()
	selection_area.connect("selection_area_triggered", self, "select_entity")

# Select a entity
func select_entity(entity = null):
	breakpoint
	emit_signal("deselect_entity")
	
	if not entity == null:
		selected_entity = entity
		var selection_area = get_selection_area(entity)
		selection_area.mark_as_selected()

func get_selection_area(entity):
	return entity.get_node("SelectionArea")

func deselect_entity(entity = null):
	if entity == null:
		return
	
	var selection_area = get_selection_area(entity)
	selection_area.mark_as_deselected()
	selected_entity = null

# Determine if entity has a selection node.
func has_selection_area(entity):
	return get_selection_area(entity) != null

# Determine if entity is selected.
func is_entity_selected(entity):
	if not has_selection_area(entity):
		return false
	
	return get_selection_area(entity).selected

# Determine if unit is selectable.
func is_entity_selectable(entity):
	return has_selection_area(entity)

# Determine if an input position is within selection area.
# Not currently being used.
func is_pos_in_entity_selection(entity, pos):
	var selection_node = entity.get_node("SelectionNode")