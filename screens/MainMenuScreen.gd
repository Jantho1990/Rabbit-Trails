extends Control

onready var background = $MainMenuBackgroundCave
onready var background_camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print('MAIN MENU')
#	background.position = Vector2(rect_size.x / 2, rect_size.y / 2)
	background_camera.current = true
	background_camera.position = Vector2(rect_size.x / 2, rect_size.y / 2)
#	background.position = Vector2(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_pressed():
#	breakpoint
	UserData.set('current_stage_name', 'TutorialStage')
	get_tree().change_scene('res://screens/GameScreen.tscn')
