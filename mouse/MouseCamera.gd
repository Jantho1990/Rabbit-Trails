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
	else:
		locked = false
#		position = previous_active_camera.camera.get_camera_screen_center()
		camera.align()
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
	if not locked:
		position = get_global_mouse_position()
	else:
		position = ActiveCameraManager.get_active_camera().camera.get_camera_screen_center()
	update()
	GlobalSignal.dispatch('debug_label', { 'text': position })

# Called every frame. 'delta' is the elapsed time since the previous frame.
var motion
func _input(event):
#	pass
#	GlobalSignal.dispatch('debug_label', { 'text': get_global_mouse_position() })
#	if is_nan(get_global_mouse_position().x):
#		breakpoint
#	if event is InputEventMouseMotion:
##		position = event.global_position
#		if mouse_captured:
#			pass
##			position += (event.relative * event.speed * 2)
##			var ms = get_viewport().get_mouse_position()
##			breakpoint
##		motion = Input.get_last_mouse_speed()
##		position += motion.normalized() * 45
	
#	if event is InputEventMouseButton:
##		breakpoint
#		pass
	
	if event is InputEventKey:
		if event.is_action_pressed('ui_cancel'):
			if mouse_captured:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_captured = false
			elif not mouse_captured:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
				mouse_captured = true
#		breakpoint
#	clamp_camera()

func _draw():
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