extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show():
	visible = true
	get_tree().paused = true
	$MarginContainer/CenterContainer/VBoxContainer/EmployeeEfficiencyIndexDisplay.set_data()

func _on_MenuButton_pressed():
	get_tree().paused = false
	ActiveCameraManager.deactivate_active_camera()
	ActiveCameraManager.remove_all_cameras()
	Rabbits.reset()
	Rabbits.all_rabbits_added = false
#	GlobalSignal.clear()
	Selection.reset()
	get_tree().change_scene('res://screens/MainMenuScreen.tscn')

func _on_ReplayButton_pressed():
	get_tree().paused = false
	GlobalSignal.dispatch('restart_stage')
