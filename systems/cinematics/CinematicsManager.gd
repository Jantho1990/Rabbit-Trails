extends Node

var cinematic_marks = {}

onready var marks = $Marks
onready var camera = $CinematicCamera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in marks.get_children():
		if child is CinematicMark2D:
			cinematic_marks[child.mark_name] = child

func get_mark(mark_name):
	if cinematic_marks.has(mark_name):
		return cinematic_marks[mark_name]
	print('No trigger named "', mark_name, '"')

func focus_on_mark(mark_name):
	var mark = get_mark(mark_name)
	if not mark:
		return
	camera.current = true
	camera.position = mark.position
	camera.current = false