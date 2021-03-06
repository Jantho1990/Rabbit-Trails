extends HBoxContainer

onready var rabbits_alive_display = $HBoxContainer/RabbitsAlive
onready var rabbits_captured_display = $HBoxContainer/RabbitsCaptured
onready var rabbits_dead_display = $HBoxContainer/RabbitsDead

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('rabbits_reset', self, '_on_Rabbits_reset')
	GlobalSignal.listen('rabbit_added', self, '_on_Rabbits_updated')
	GlobalSignal.listen('rabbit_captured', self, '_on_Rabbits_updated')
	GlobalSignal.listen('rabbit_died', self, '_on_Rabbits_updated')

func _on_Rabbits_reset():
	rabbits_alive_display.set_value(String(0).pad_zeros(2))
	rabbits_captured_display.set_value(String(0).pad_zeros(2))
	rabbits_dead_display.set_value(String(0).pad_zeros(2))

func _on_Rabbits_updated(data):
	rabbits_alive_display.set_value(String(data.alive).pad_zeros(2))
	rabbits_captured_display.set_value(String(data.captured).pad_zeros(2))
	rabbits_dead_display.set_value(String(data.dead).pad_zeros(2))