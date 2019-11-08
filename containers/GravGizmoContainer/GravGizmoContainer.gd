extends "res://containers/EntityContainer/EntityContainer.gd"

class_name GravGizmoContainer

func _init().():
	container_type = "GravGizmo"
	container_callback = "on_Add_GravGizmo"
	container_callback_remove = "on_Remove_GravGizmo"

func on_Add_GravGizmo(data):
	if data.container_id == container_id:
		var entity = data.entity
		if data.instance == true:
			entity = entity.instance()
	
		add_child(entity)

func on_Remove_GravGizmo(data):
	on_Remove_entity(data)