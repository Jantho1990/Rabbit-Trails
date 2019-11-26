extends BaseStage

class_name TutorialStage

###
# Tutorial stage, where we teach the player how to play the game.
###

onready var cinematics = $Cinematics
onready var triggers = $Triggers

func _ready():
	GlobalSignal.listen('OpeningDialogue_stopped', self, '_on_OpeningDialogue_stopped')
	GlobalSignal.listen('dialogue_finished', self, '_on_Dialogue_finished')
	triggers.get_trigger('OpeningDialogue').start(1.5)
#	cinematics.get_mark('LevelStart')
	cinematics.focus_on_mark('LevelStart')
#	GlobalSignal.dispatch('victory', { 'next_stage': 'SwitchTestStage' })
#	GlobalSignal.dispatch('defeat', {})
	Budget.set_money(15000)

func _on_OpeningDialogue_stopped():
	GlobalSignal.dispatch('dialogue', {
		'func_name': 'initiate',
		'file_id': 'test_dialogue_1',
	})
	cinematics.move_to_mark('OpeningDialogue')

func _on_Dialogue_finished(data):
	var dialogue = data.dialogue
	if dialogue.has('file_id') and dialogue.file_id == 'test_dialogue_1':
		GlobalSignal.dispatch('victory', { 'next_stage': 'SwitchTestStage' })