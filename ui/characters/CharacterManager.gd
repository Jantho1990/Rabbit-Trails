extends Control

signal change_character

export(Array, String, FILE, '*.tscn') var characters
export(Array, String, FILE, '*.tscn') var backgrounds

var _loaded_characters = {} setget _private_set,get_loaded_characters
var _loaded_backgrounds = {} setget _private_set,get_loaded_backgrounds

var current_character
var current_background

func _private_set(__throwaway__):
	print('Private variable.')

func _ready():
	connect('change_character', self, '_on_Change_character')	
	if characters.size() > 0:
		for character in characters:
			var loaded_character = load(character).instance()
			_loaded_characters[loaded_character.character_name] = loaded_character
	if backgrounds.size() > 0:
		for background in backgrounds:
			var loaded_background = load(background).instance()
			_loaded_backgrounds[loaded_background.background_name] = loaded_background
	
	#Test
#	_on_Change_character({
#		'character_name': 'Super Tester',
#		'background_name': 'Noise'
#	})

func _on_Change_character(data):
	print('FOUND IT')
	var character_name = data.character_name
	
	if data.has('background_name'):
		var background_name = data.background_name
		display_background(background_name)
	
	display_character(character_name)

func get_loaded_characters():
	return _loaded_characters

func get_loaded_backgrounds():
	return _loaded_backgrounds

func get_character(character_name):
	if _loaded_characters.has(character_name):
		return _loaded_characters[character_name]
	print('No character found named ', character_name)

func get_background(background_name):
	if _loaded_backgrounds.has(background_name):
		return _loaded_backgrounds[background_name]
	print('No background found named ', background_name)

func display_character(character_name):
	var character = get_character(character_name)
	if current_character != character:
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