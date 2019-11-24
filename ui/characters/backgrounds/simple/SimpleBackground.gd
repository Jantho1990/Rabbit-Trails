extends Node2D

export(String) var background_name = 'Simple Background'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play(anim = 'play'):
	if $AnimationPlayer:
		$AnimationPlayer.play(anim)