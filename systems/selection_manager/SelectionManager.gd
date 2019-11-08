extends Node

signal select_entity
signal deselect_entity

# Names of entities which should be selectable
export(Array, String) var selectable_entities = []

# The currently selected entity
var selected_entity = null

# The previously selected entity
var previously_selected_entity = null

# True if entity was recently deselected
var entity_recently_deselected = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entity_recently_deselected:
		entity_recently_deselected = false

func _input(event):
	if not event is InputEventMouseButton:
		return
		
	if event.pressed:
		pass

func register_entity(entity):
	var selection_area = entity.get_node("SelectionArea")
	selection_area.register_entity()
	selection_area.connect("selection_area_triggered", self, "select_entity")

# Clears any selected entity so nothing is selected.
func clear_selection():
	deselect_entity(selected_entity)
	previously_selected_entity = selected_entity
	selected_entity = null
	entity_recently_deselected = true
	print("cleared!")

# Select a entity
func select_entity(entity = null):
#	breakpoint
#	if suppress_selection:
#		return
	if is_entity_selected(entity) or \
		(entity_recently_deselected and entity == previously_selected_entity):
			return
	
	deselect_entity(selected_entity)
	
	if not entity == null:
		selected_entity = entity
		var selection_area = get_selection_area(entity)
		selection_area.mark_as_selected()
		print("selected", selected_entity)

func get_selection_area(entity):
	return entity.get_node("SelectionArea")

func deselect_entity(entity = null):
	if entity == null:
		return
	
	var selection_area = get_selection_area(entity)
	selection_area.mark_as_deselected()

# Determine if there is a selected unit.
func has_selection():
	return selected_entity != null

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