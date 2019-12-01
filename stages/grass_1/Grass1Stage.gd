extends BaseStage

class_name Grass1Stage

###
# Grass Stage 1.
###

func _ready():
	Budget.set_money(starting_budget)
	Rabbits.reset()
	
	# Dialogue variable resets
	GlobalSignal.listen('dialogue_finished', self, '_on_Dialogue_finished')
	
	# Triggers
#	GlobalSignal.dispatch('rabbit_hole_activate')
	triggers.get_trigger('RabbitStart').start(77)
	
	# Cinematics
	cinematics.focus_on_mark('LevelStart')
	GlobalSignal.listen('grass_1_cinematic_mark', self, '_on_Cinematic_mark')
	
	GlobalSignal.dispatch('dialogue', {
		'func_name': 'initiate',
		'file_id': 'grass_1',
	})

func _physics_process(delta):
	if Rabbits.all_rabbits_added and Rabbits.rabbits_alive == 0:
		GlobalSignal.dispatch('dialogue', {
			'func_name': 'initiate',
			'file_id': 'grass_1_end',
		})
		

func _on_Cinematic_mark(data):
	cinematics.move_to_mark(data.mark_name)

func _on_RabbitStart_timeout():
	GlobalSignal.dispatch('rabbit_hole_activate')
	GlobalSignal.dispatch('dialogue', {
		'func_name': 'initiate',
		'file_id': 'grass_1_rabbits_moving',
	})

func _on_Dialogue_finished(data):
	var dialogue = data.dialogue
	if dialogue.has('file_id'):
		match dialogue.file_id:
			'grass_1_end':
				GlobalSignal.dispatch('end_stage', {
					'next_stage': '',
					'passing_score': passing_score,
					'time_elapsed': StageManager.stage_time
				})