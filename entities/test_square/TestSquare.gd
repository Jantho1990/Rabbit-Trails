extends KinematicBody2D

class_name TestSquare

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("entities")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Run when the unit is selected.
func _on_selected():
	pass

# Run when the unit is deselected.
func _on_deselection():
	pass