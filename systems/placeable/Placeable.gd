extends Node

###
# Dependencies:
# - SelectionManager
# - a parent node
###

# Can entity be placed
var allowed_to_place = false

# Can entity be moved
var allowed_to_move = false

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('move_unit', self, 'on_Move_unit')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func on_Move_unit():
	print('hit')
	if Selection.selected_entity == parent or Selection.previously_selected_entity == parent:
		print("moving unit")
	else:
		breakpoint