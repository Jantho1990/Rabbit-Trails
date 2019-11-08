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
	parent.queue_free()