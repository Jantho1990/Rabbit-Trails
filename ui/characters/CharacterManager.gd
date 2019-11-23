extends Control

signal change_character

export(Array, String, FILE, '*.tscn') var characters

var _loaded_characters = {} setget _private_set,get_loaded_characters

var current_character

func _private_set(__throwaway__):
	connect('change_character', self, '_on_Change_character')
	print('Private variable.')

func _ready():
	if characters.size() > 0:
		for character in characters:
			var loaded_character = load(character).instance()
			_loaded_characters[loaded_character.character_name] = loaded_character
	
	#Test
	display_character('Super Tester')

func _on_Change_character(data):
	var character_name = data.character_name
	display_character(character_name)

func get_loaded_characters():
	return _loaded_characters

func get_character(character_name):
	if _loaded_characters.has(character_name):
		return _loaded_characters[character_name]
	print('No character found named ', character_name)

func display_character(character_name):
	var character = get_character(character_name)
	if current_character != character:
		remove_child(current_character)
		current_character = character
		add_child(current_character)
		current_character.position = Vector2(rect_size.x / 2, rect_size.y / 2)