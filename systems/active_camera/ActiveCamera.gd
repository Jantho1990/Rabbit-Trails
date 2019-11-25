extends Camera2D

export(String) var camera_name = 'Active Camera'

# Called when the node enters the scene tree for the first time.
func _ready():
	ActiveCameraManager.register(camera_name, self)