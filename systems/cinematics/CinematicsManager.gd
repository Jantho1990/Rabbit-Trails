extends Node

var cinematic_marks = {}

onready var marks = $Marks
onready var camera = $CinematicCamera2D

var current_mark = null

var mark_active = false
var mark_move_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in marks.get_children():
		if child is CinematicMark2D:
			cinematic_marks[child.mark_name] = child

func _physics_process(delta):
	if mark_active and not mark_move_active:
		deactivate_mark()
	
	if mark_move_active:
#		var prev_cam = ActiveCameraManager.get_previous_camera()
		camera.position = lerp(camera.position, current_mark.position, 0.05)
		if camera.position.distance_to(current_mark.position) < 1:
			mark_move_active = false
#			camera.camera.smoothing_enabled = false

func get_mark(mark_name):
	if cinematic_marks.has(mark_name):
		return cinematic_marks[mark_name]
	print('No trigger named "', mark_name, '"')

func focus_on_mark(mark_name):
	var mark = get_mark(mark_name)
	if not mark:
		return
	
	current_mark = mark
	mark_active = true
	ActiveCameraManager.activate_camera(camera.camera_name)
	camera.position = mark.position
	camera.camera.align()

func move_to_mark(mark_name):
	var mark = get_mark(mark_name)
	if not mark:
		return
	
	current_mark = mark
	mark_active = true
	mark_move_active = true
	ActiveCameraManager.activate_camera(camera.camera_name)
#	camera.camera.smoothing_enabled = true
#	camera.position = mark.position
#	camera.camera.align()

func deactivate_mark():
	mark_active = false
	mark_move_active = false
	current_mark = null
	ActiveCameraManager.activate_previous_camera()