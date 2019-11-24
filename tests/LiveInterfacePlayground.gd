extends Node

func _ready():
	GlobalSignal.dispatch('dialogue', {
		'func_name': 'initiate',
		'file_id': 'test_dialogue_1',
	})