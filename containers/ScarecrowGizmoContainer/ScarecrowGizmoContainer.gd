extends "res://containers/EntityContainer/EntityContainer.gd"

class_name ScarecrowGizmoContainer

func _init().():
	container_type = "ScarecrowGizmo"
	container_callback = "on_Add_ScarecrowGizmo"
	container_callback_remove = "on_Remove_ScarecrowGizmo"

func on_Add_ScarecrowGizmo(data):
	if data.container_id == container_id:
		var entity = data.entity
		if data.instance == true:
			entity = entity.instance()
	
		add_child(entity)

func on_Remove_ScarecrowGizmo(data):
	on_Remove_entity(data)