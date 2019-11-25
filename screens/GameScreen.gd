extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if not ActiveCameraManager.has_active_camera():
		ActiveCameraManager.activate_camera('MouseCamera') # We want this to be the active camera by default, unless something else took it first.