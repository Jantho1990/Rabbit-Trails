extends BaseStage

class_name Grass1Stage

###
# Grass Stage 1.
###

func _ready():
	Budget.set_money(starting_budget)
	Rabbits.reset()
	
	# Dialogue variable resets

	
	# Triggers
	GlobalSignal.dispatch('rabbit_hole_activate')
#	triggers.get_trigger('OpeningDialogue').start(1.5)
	
	# Cinematics
	cinematics.focus_on_mark('LevelStart')

func _physics_process(delta):
	if Rabbits.all_rabbits_added and Rabbits.rabbits_alive == 0:
		GlobalSignal.dispatch('end_stage', {
			'next_stage': 'SwitchTestStage',
			'passing_score': passing_score,
			'time_elapsed': StageManager.stage_time
		})