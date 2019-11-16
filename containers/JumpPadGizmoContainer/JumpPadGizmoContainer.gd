extends "res://containers/EntityContainer/EntityContainer.gd"

class_name JumpPadGizmoContainer

func _init().():
	container_type = "JumpPadGizmo"
	container_callback = "on_Add_JumpPadGizmo"
	container_callback_remove = "on_Remove_JumpPadGizmo"

func on_Add_JumpPadGizmo(data):
	if data.container_id == container_id:
		var entity = data.entity
		if data.instance == true:
			entity = entity.instance()
	
		add_child(entity)

func on_Remove_JumpPadGizmo(data):
	on_Remove_entity(data)