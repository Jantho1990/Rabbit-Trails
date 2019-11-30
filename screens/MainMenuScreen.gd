extends Control

onready var background = $MainMenuBackgroundCave

# Called when the node enters the scene tree for the first time.
func _ready():
	background.position = Vector2(rect_size.x / 2, rect_size.y / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_pressed():
	UserData.set('current_stage_name', 'TutorialStage')
	get_tree().change_scene('res://screens/GameScreen.tscn')
