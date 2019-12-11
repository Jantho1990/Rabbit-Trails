extends Control

signal change_character
signal hide_character
signal show_transition
signal hide_transition

export(Array, String, FILE, '*.tscn') var characters
export(Array, String, FILE, '*.tscn') var backgrounds

var _loaded_characters = {} setget _private_set,get_loaded_characters
var _loaded_backgrounds = {} setget _private_set,get_loaded_backgrounds

var current_character
var current_background

export(String) var default_background = 'SolidBackground'
export(String) var transition_background = 'Static'

var show_transition = false
var transition

onready var transition_tween = $TransitionTween

func _private_set(__throwaway__):
	print('Private variable.')

func _ready():
	connect('change_character', self, '_on_Change_character')
	connect('hide_character', self, '_on_Hide_character')
	connect('show_transition', self, '_on_Show_transition')
	connect('hide_transition', self, '_on_Hide_transition')
	transition_tween.connect('tween_all_completed', self, '_on_TransitionTween_completed')
	if characters.size() > 0:
		for character in characters:
			var loaded_character = load(character).instance()
			_loaded_characters[loaded_character.character_name] = loaded_character
	if backgrounds.size() > 0:
		for background in backgrounds:
			var loaded_background = load(background).instance()
			_loaded_backgrounds[loaded_background.background_name] = loaded_background
	
	display_background(default_background)
	
	transition = _loaded_backgrounds[transition_background]
	transition.modulate = Color(1, 1, 1, 0)
	transition.position = Vector2(rect_size.x / 2, rect_size.y / 2)
	transition.z_index = 100
	
	#Test
#	_on_Change_character({
#		'character_name': 'Super Tester',
#		'background_name': 'Noise'
#	})

func _on_Change_character(data):
#	print('FOUND IT')
	var character_name = data.character_name
	
	if data.has('background_name'):
		var background_name = data.background_name
		display_background(background_name)
	
	display_character(character_name)

func _on_Hide_character():
	hide_character()
	display_background(default_background)

func _on_Show_transition():
	show_transition()

func _on_Hide_transition():
#	print('HIDE')
	hide_transition()

func get_loaded_characters():
	return _loaded_characters

func get_loaded_backgrounds():
	return _loaded_backgrounds

func get_character(character_name):
	if _loaded_characters.has(character_name):
		return _loaded_characters[character_name]
	print('No character found named ', character_name)

func hide_character():
	if current_character:
		remove_child(current_character)
		current_character = null

func reset_character():
	hide_character()
	current_character = null

func get_background(background_name):
	if _loaded_backgrounds.has(background_name):
		return _loaded_backgrounds[background_name]
	print('No background found named ', background_name)

func display_character(character_name):
	var character = get_character(character_name)
	if current_character != character:
		if current_character != null:
			remove_child(current_character)
		current_character = character
		add_child(current_character)
		current_character.position = Vector2(rect_size.x / 2, rect_size.y / 2)

func display_background(background_name):
	var background = get_background(background_name)
	if current_background != background:
		remove_child(current_background)
		current_background = background
		add_child(current_background)
		current_background.position = Vector2(rect_size.x / 2, rect_size.y / 2)

func show_transition(time = 0.2):
#	display_background(transition_background)
	show_transition = true
	add_child(transition)
	if transition.has_node('AnimationPlayer'):
		transition.play()
	transition_tween.interpolate_property(transition, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 1), time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	transition_tween.start()
#	breakpoint

func hide_transition(time = 0.2):
	if transition_tween.is_active():
		transition_tween.remove_all()
	show_transition = false
	transition_tween.interpolate_property(transition, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), time , Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	transition_tween.start()

func _on_TransitionTween_completed():
	if not show_transition:
		remove_child(transition)
	elif show_transition:
		transition_tween.remove_all()
		hide_character()