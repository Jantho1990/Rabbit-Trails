extends Area2D

class_name Trigger

###
# A simple area node which dispatches an event when something enters its area.
# It is the repsonsibility of entities watching its event to react to it.
# All triggers must be uniquely named.
###

export(String) var trigger_name = 'Trigger'

var first_time = true

onready var trigger_entered = trigger_name + '_entered'
onready var trigger_exited = trigger_name + '_exited'

onready var collision_area = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalSignal.has_listeners(trigger_entered) or GlobalSignal.has_listeners(trigger_exited):
		print('Trigger name "', trigger_name, '" already exists.')
	
	connect('area_entered', self, '_on_Trigger_entered')
	connect('area_exited', self, '_on_Trigger_exited')

func _on_Trigger_entered(collider):
	GlobalSignal.dispatch(trigger_entered, { 'collider': collider })

func _on_Trigger_exited(collider):
	GlobalSignal.dispatch(trigger_exited, { 'collider': collider })