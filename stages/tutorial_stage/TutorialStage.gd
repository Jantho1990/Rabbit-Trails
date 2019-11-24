extends BaseStage

class_name TutorialStage

###
# Tutorial stage, where we teach the player how to play the game.
###

onready var triggers = $Triggers

func _ready():
	GlobalSignal.listen('OpeningDialogue_stopped', self, '_on_OpeningDialogue_stopped')
	triggers.get_trigger('OpeningDialogue').start(1.5)

func _on_OpeningDialogue_stopped():
	GlobalSignal.dispatch('dialogue', {
		'func_name': 'initiate',
		'file_id': 'test_dialogue_1',
	})