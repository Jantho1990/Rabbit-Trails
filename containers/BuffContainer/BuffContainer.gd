extends "res://containers/EntityContainer/EntityContainer.gd"

func _init().():
	container_type = "Buff"
	container_callback = "on_Add_buff"

func on_Add_buff(data):
	# apply buff to target
	var buff = data.Buff.instance()
	buff.duration = data.duration
	buff.target = data.target
	
	add_child(buff)