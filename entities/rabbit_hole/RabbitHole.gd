extends EntityGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('rabbit_hole_activate', self, '_on_Rabbit_hole_activate')
	GlobalSignal.listen('add_entity', self, '_on_Add_entity')
	print('rabbit hole ready')

func _on_Rabbit_hole_activate():
	active = true

func _on_Rabbit_hole_deactivate():
	active = false

func _on_Add_entity(data):
	var entity = data.entity
	if entity is Rabbit:
		Rabbits.add_rabbit()