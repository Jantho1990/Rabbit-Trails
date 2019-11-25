extends Node

var cameras = {}

var active_camera = null

func register(camera_name, camera):
	cameras[camera_name] = {
		'name': camera_name,
		'camera': camera,
		'active': false
	}

func activate_camera(camera_name):
	if cameras.has(camera_name):
		if active_camera:
			active_camera.camera.current = false
		active_camera = cameras[camera_name]
		active_camera.camera.current = true
	print('No camera named "', camera_name, '" in Active Cameras.')

func deactivate_active_camera():
	if active_camera:
		active_camera.camera.current = false
		active_camera = null

func get_active_camera():
	return active_camera