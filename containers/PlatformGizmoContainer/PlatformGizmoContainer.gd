extends "res://containers/EntityContainer/EntityContainer.gd"

class_name PlatformGizmoContainer

func _init().():
	container_type = "PlatformGizmo"
	container_callback = "on_Add_PlatformGizmo"
	container_callback_remove = "on_Remove_PlatformGizmo"

func on_Add_PlatformGizmo(data):
	if data.container_id == container_id:
		var entity = data.entity
		if data.instance == true:
			entity = entity.instance()
	
		add_child(entity)

func on_Remove_PlatformGizmo(data):
	on_Remove_entity(data)