extends Node2D

var screen_size

var mouse_captured = false
var mouse_speed = 5

onready var camera = $ActiveCamera2D

var vr
var vs

var locked = false
# Called when the node enters the scene tree for the first time.
func _ready():
#	vr = get_viewport()
	vs = get_viewport_rect()
	screen_size = get_viewport().size
#	GlobalSignal.listen('resize_camera_bounds', self, '_on_Resize_camera_bounds')
	GlobalSignal.listen('active_camera_changed', self, '_on_Active_camera_changed')

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Allows the camera limits to be resized, e.g. by a tilemap to prevent scrolling outside the map.
func _on_Resize_camera_bounds(data):
	var bounds = data.bounds
	camera.limit_bottom = bounds.bottom
	camera.limit_top = bounds.top
	camera.limit_left = bounds.left
	camera.limit_right = bounds.right
#	breakpoint

func _on_Active_camera_changed(data):
	var active_camera = data.current
	var previous_active_camera = data.previous
	if active_camera.name != camera.camera_name:
#		breakpoint
		locked = true
#		print('CORN')
	else:
		locked = false
#		position = previous_active_camera.camera.get_camera_screen_center()
		camera.align()
#		print('PEAS')
#		camera.force_update_scroll()
	
#	if active_camera.name == camera.camera_name:
#		position = previous_active_camera.camera.position
#		var t1 = Timer.new()
#		add_child(t1)
#		t1.one_shot = true
#		t1.connect('timeout', self, '_on_Timeout')
#		t1.start(0.01)
#		locked = true
#		breakpoint

func _on_Timeout():
	locked = false

func _physics_process(delta):
	if not get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	if not locked:
		position = get_global_mouse_position()
	else:
		position = ActiveCameraManager.get_active_camera().camera.get_camera_screen_center()
#	update()
#	GlobalSignal.dispatch('debug_label', { 'text': position })

func _draw():
	return
	draw_circle(Vector2(0, 0), 3, Color(1, 0, 0))

#func clamp_camera():
#	if position.x > screen_size.x:
#		position.x = screen_size.x
#	elif position.x < 0:
#		position.x = 0
#
#	if position.y > screen_size.y:
#		position.y = screen_size.y
#	elif position.y < 0:
#		position.y = 0