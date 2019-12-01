extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewGameButton.connect('pressed', self, '_on_NewGameButton_pressed')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_NewGameButton_pressed():
#	breakpoint
	UserData.set('current_stage_name', 'TutorialStage')
	get_tree().change_scene('res://screens/GameScreen.tscn')
