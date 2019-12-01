extends BaseStage

class_name TutorialStage

###
# Tutorial stage, where we teach the player how to play the game.
###

onready var cinematics = $Cinematics
onready var triggers = $Triggers

func _ready():
	GlobalSignal.listen('OpeningDialogue_stopped', self, '_on_OpeningDialogue_stopped')
#	GlobalSignal.listen('dialogue_finished', self, '_on_Dialogue_finished')
	triggers.get_trigger('OpeningDialogue').start(1.5)
#	cinematics.get_mark('LevelStart')
	cinematics.focus_on_mark('LevelStart')
#	GlobalSignal.dispatch('victory', { 'next_stage': 'SwitchTestStage' })
#	GlobalSignal.dispatch('defeat', {})
	GlobalSignal.listen('RabbitAdvanced_entered', self, '_on_RabbitAdvanced_entered')
	Budget.set_money(5000)
	Rabbits.reset()
	GlobalSignal.dispatch('rabbit_hole_activate')
	
	if PROGRESS.variables.has('skip_tutorial'):
		PROGRESS.variables.skip_tutorial = false
	if PROGRESS.variables.has('tutorial_intro_complete'):
		PROGRESS.variables.tutorial_intro_complete = false

func _physics_process(delta):
	if Rabbits.all_rabbits_added and Rabbits.rabbits_alive == 0:
		GlobalSignal.dispatch('end_stage', {
			'next_stage': 'SwitchTestStage',
			'passing_score': passing_score,
			'time_elapsed': StageManager.stage_time
		})

func _on_OpeningDialogue_stopped():
	GlobalSignal.dispatch('dialogue', {
		'func_name': 'initiate',
		'file_id': 'tutorial_0',
	})
	cinematics.move_to_mark('OpeningDialogue')

func _on_RabbitAdvanced_entered(data):
#	breakpoint
	if data.collider is Rabbit:
		if PROGRESS.variables.has('skip_tutorial') and PROGRESS.variables.skip_tutorial:
			return # We already triggered this.
		if not PROGRESS.variables.has('tutorial_intro_complete') or \
			PROGRESS.variables.tutorial_intro_complete == false:
				PROGRESS.variables['skip_tutorial'] = true
				GlobalSignal.dispatch('dialogue', {
					'func_name': 'initiate',
					'file_id': 'skip_tutorial'
				})

func _on_Dialogue_finished(data):
	var dialogue = data.dialogue
	if dialogue.has('file_id') and dialogue.file_id == 'test_dialogue_1':
		GlobalSignal.dispatch('victory', { 'next_stage': 'SwitchTestStage' })