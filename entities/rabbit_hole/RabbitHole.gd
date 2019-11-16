extends EntityGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('rabbit_hole_activate', self, '_on_Rabbit_hole_activate')
	print('rabbit hole ready')

func _on_Rabbit_hole_activate():
	active = true

func _on_Rabbit_hole_deactivate():
	active = false