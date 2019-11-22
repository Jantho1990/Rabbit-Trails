extends Node

onready var dialogue = $InterfaceLayer/UI/DialogueCard/RTDialogue

# Called when the node enters the scene tree for the first time.
func _ready():
	print('ready')
	dialogue.initiate('test_dialogue_1')
	print('boom headshot')

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		dialogue.next()