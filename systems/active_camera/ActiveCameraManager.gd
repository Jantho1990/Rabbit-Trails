extends Node

var cameras = {}

var active_camera = null

func _ready():
	GlobalSignal.listen('active_camera_resize_bounds', self, '_on_Resize_camera_bounds')


func register(camera_name, camera):
	cameras[camera_name] = {
		'name': camera_name,
		'camera': camera,
		'active': false
	}
	print(camera_name, ' was registered', cameras.has(camera_name))
	if not has_active_camera(): # If this is the first camera, activate it.
		activate_camera(camera_name)

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
		active_camera = cameras[camera_name]
		active_camera.camera.current = true
	else:
		print('No camera named "', camera_name, '" in Active Cameras.', cameras)

func deactivate_active_camera():
	if active_camera:
		active_camera.camera.current = false
		active_camera = null

func get_active_camera():
	return active_camera

func has_active_camera():
	return !!active_camera