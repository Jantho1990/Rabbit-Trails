extends Node2D

export(String) var camera_name = 'Cinematic Camera'

onready var camera = $ActiveCamera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.camera_name = camera_name
	ActiveCameraManager.register(camera_name, camera)