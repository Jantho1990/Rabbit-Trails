extends "res://containers/EntityContainer/EntityContainer.gd"

class_name ThrustGizmoContainer

func _init().():
	container_type = "ThrustGizmo"
	container_callback = "on_Add_ThrustGizmo"
	container_callback_remove = "on_Remove_ThrustGizmo"

func on_Add_ThrustGizmo(data):
	if data.container_id == container_id:
		var entity = data.entity
		if data.instance == true:
			entity = entity.instance()
	
		add_child(entity)

func on_Remove_ThrustGizmo(data):
	on_Remove_entity(data)