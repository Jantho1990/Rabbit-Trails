extends BaseStage

class_name TutorialStage

###
# Tutorial stage, where we teach the player how to play the game.
###

func _ready():
	Budget.set_money(starting_budget)
	Rabbits.reset()
	
	# Dialogue variable resets
	if PROGRESS.variables.has('skip_tutorial'):
		PROGRESS.variables.skip_tutorial = false
	if PROGRESS.variables.has('tutorial_intro_complete'):
		PROGRESS.variables.tutorial_intro_complete = false
	
	# Triggers
	GlobalSignal.listen('dialogue_finished', self, '_on_Dialogue_finished')
	GlobalSignal.listen('OpeningDialogue_stopped', self, '_on_OpeningDialogue_stopped')
	GlobalSignal.listen('RabbitAdvanced_entered', self, '_on_RabbitAdvanced_entered')
	GlobalSignal.listen('tutorial_cinematic_mark', self, '_on_Cinematic_mark')
	GlobalSignal.dispatch('rabbit_hole_activate')
	triggers.get_trigger('OpeningDialogue').start(1.5)
	
	# Cinematics
	cinematics.focus_on_mark('LevelStart')

func _physics_process(delta):
	if Rabbits.all_rabbits_added and Rabbits.rabbits_alive == 0:
		GlobalSignal.dispatch('end_stage', {
			'next_stage': 'SwitchTestStage',
			'passing_score': passing_score,
			'time_elapsed': StageManager.stage_time
		})

func _on_Dialogue_finished(data):
	var dialogue = data.dialogue
	if dialogue.has('file_id'):
		match dialogue.file_id:
			'tutorial_0':
				if not PROGRESS.variables.has('skip_tutorial') or \
					PROGRESS.variables.skip_tutorial:
						GlobalSignal.dispatch('dialogue', {
							'func_name': 'initiate',
							'file_id': 'tutorial_explanation',
						})

###
# Responses to triggers
###

func _on_Cinematic_mark(data):
	cinematics.move_to_mark(data.mark_name)

func _on_OpeningDialogue_stopped():
	GlobalSignal.dispatch('dialogue', {
		'func_name': 'initiate',
		'file_id': 'tutorial_0',
	})
#	cinematics.move_to_mark('OpeningDialogue')

func _on_RabbitAdvanced_entered(data):
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