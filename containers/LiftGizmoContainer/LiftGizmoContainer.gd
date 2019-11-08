extends "res://containers/EntityContainer/EntityContainer.gd"

class_name LiftGizmoContainer

func _init().():
	container_type = "LiftGizmo"
	container_callback = "on_Add_LiftGizmo"
	container_callback_remove = "on_Remove_LiftGizmo"

func on_Add_LiftGizmo(data):
	if data.container_id == container_id:
		var entity = data.entity
		if data.instance == true:
			entity = entity.instance()
	
		add_child(entity)

func on_Remove_LiftGizmo(data):
	on_Remove_entity(data)