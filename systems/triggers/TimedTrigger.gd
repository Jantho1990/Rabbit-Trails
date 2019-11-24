extends Timer

class_name TimedTrigger

###
# A simple timer node which dispatches an event when its timer starts or stops.
# It is the repsonsibility of entities watching its event to react to it.
# All triggers must be uniquely named.
###

export(String) var trigger_name = 'Trigger'

var first_time = true

onready var trigger_started = trigger_name + '_started'
onready var trigger_stopped = trigger_name + '_stopped'

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalSignal.has_listeners(trigger_started) or GlobalSignal.has_listeners(trigger_stopped):
		print('Trigger name "', trigger_name, '" already exists.')
	
	connect('timeout', self, '_on_Timer_timeout')

func start(time_sec : float = 1.0):
	.start(time_sec)
	GlobalSignal.dispatch(trigger_started)

func _on_Timer_timeout():
	GlobalSignal.dispatch(trigger_stopped)
	stop()