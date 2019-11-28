extends "res://containers/EntityContainer/EntityContainer.gd"

class_name SlowdownGizmoContainer

func _init().():
	container_type = "SlowdownGizmo"
	container_callback = "on_Add_SlowdownGizmo"
	container_callback_remove = "on_Remove_SlowdownGizmo"

func on_Add_SlowdownGizmo(data):
	if data.container_id == container_id:
		var entity = data.entity
		if data.instance == true:
			entity = entity.instance()
	
		add_child(entity)

func on_Remove_SlowdownGizmo(data):
	on_Remove_entity(data)