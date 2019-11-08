extends "res://containers/EntityContainer/EntityContainer.gd"

class_name EnemyContainer

# The name of the callback function when the add event is registered.
# This is meant to be set in code by whatever classes extend this
# default entity container.
#var container_callback = "on_Add_enemy" # Godot doesn't allow redefinition here...need to research

func _init().():
	container_type = "Enemy"
	container_callback = "on_Add_enemy"

func on_Add_enemy(data):
	if data.container_id == container_id:
		var enemy = data.enemy
		if data.instance == true:
			enemy = enemy.instance()
	
		add_child(enemy)