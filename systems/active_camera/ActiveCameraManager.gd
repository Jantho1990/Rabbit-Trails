extends Node

var cameras = {}

var active_camera = null

var previous_active_camera_name = ''

func _ready():
	GlobalSignal.listen('active_camera_resize_bounds', self, '_on_Resize_camera_bounds')

#func _process(delta):
#	GlobalSignal.dispatch('debug_label', { 'text': ActiveCameraManager.active_camera })

func register(camera_name, camera):
	if camera.has_node('ActiveCamera2D'):
		camera = camera.get_node('ActiveCamera2D')
	cameras[camera_name] = {
		'name': camera_name,
		'camera': camera,
		'parent': camera.get_parent(),
		'active': false
	}
	print(camera_name, ' was registered', cameras.has(camera_name))
	if not has_active_camera(): # If this is the first camera, activate it.
		activate_camera(camera_name)

func remove_all_cameras():
	for camera in cameras.values():
		if is_instance_valid(camera):
			camera.camera.queue_free()
	cameras = {}

# Allows the camera limits to be resized, e.g. by a tilemap to prevent scrolling outside the map.
func _on_Resize_camera_bounds(data):
	print('SMACK', data)
	var bounds = data.bounds
	if data.has('all_cameras') and data.all_cameras:
		for camera in cameras.values():
			reset_camera_bounds(camera.camera, bounds)
		return
	
	if has_active_camera():
		reset_camera_bounds(active_camera.camera, bounds)
		return
	
	print('No active camera, ignoring bounds resize.')

func reset_camera_bounds(camera, bounds):
	camera.limit_bottom = bounds.bottom
	camera.limit_top = bounds.top
	camera.limit_left = bounds.left
	camera.limit_right = bounds.right

func activate_camera(camera_name):
	if cameras.has(camera_name):
		if active_camera:
			active_camera.camera.current = false
			previous_active_camera_name = active_camera.name
		active_camera = cameras[camera_name]
		active_camera.camera.current = true
		GlobalSignal.dispatch('active_camera_changed', {
			'current': active_camera,
			'previous': get_camera(previous_active_camera_name)
		})
	else:
		print('No camera named "', camera_name, '" in Active Cameras.', cameras)

func activate_previous_camera():
	if previous_active_camera_name == '':
		print('No previous camera, ignoring command.')
		return
	
	activate_camera(previous_active_camera_name)

func deactivate_active_camera():
	if active_camera:
		active_camera.camera.current = false
		active_camera = null

func get_active_camera():
	return active_camera

func get_previous_camera():
	if previous_active_camera_name != '':
		return get_camera(previous_active_camera_name)
	return null

func has_active_camera():
	return !!active_camera

func get_camera(camera_name):
	if cameras.has(camera_name):
		return cameras[camera_name]
	
	print('No camera with name "', camera_name, '" in Active Cameras')