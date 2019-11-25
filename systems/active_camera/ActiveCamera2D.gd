extends Camera2D

class_name ActiveCamera2D

export(String) var camera_name = 'Active Camera'
export(bool) var defer_register = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not defer_register:
		ActiveCameraManager.register(camera_name, self)