extends Node

# The name of the container. This determines what events it listens for.
# This should be changed. Otherwise, all containers will, by default, respond
# to the "add_entity" event, which is likely not desirable.
export(String) var container_id = "Entity"

var container_type = "Entity"

# The name of the callback function when the add event is registered.
# This is meant to be set in code by whatever classes extend this
# default entity container.
var container_callback = "on_Add_" + container_type
var container_callback_remove = "on_Remove_" + container_type

func _ready():
	if GlobalSignal:
		GlobalSignal.listen("add_" + container_type, self, container_callback)
		GlobalSignal.listen("remove_" + container_type, self, container_callback_remove)
	else:
		print("Container requires GlobalSignal.")

func on_Add_entity(data):
	if data.container_id == container_id:
		var entity = data.entity
		if data.instance == true:
			entity = entity.instance()
	
		add_child(entity)

func on_Remove_entity(data):
	var t = get_children().find(data.entity)
	if t != -1:
		var target = get_children()[t]
		remove_child(target)
		target.queue_free()
		
		GlobalSignal.dispatch("entity_dead", { "entity": target })

# Remove all children from the container.
func clear_children():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	print("Children cleared for ", container_id)
	GlobalSignal.dispatch(container_id + "_children_cleared")