extends Node

###
# Dependent on:
# - GlobalSignal
# - a parent
###

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('delete_unit', self, 'on_Delete_unit')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_Delete_unit():
	if Selection.selected_entity == parent: # or Selection.previously_selected_entity == parent:
		Selection.clear_selection()
		Budget.add(parent.budget_cost / 2) # Refund part of the budget_cost
		parent.queue_free()