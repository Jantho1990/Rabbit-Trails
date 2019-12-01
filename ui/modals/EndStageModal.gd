extends Control

onready var victory_modal = $VictoryModal
onready var defeat_modal = $DefeatModal
onready var screen = $Screen

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_modals()
	screen.hide()
	GlobalSignal.listen('victory', self, '_on_Victory')
	GlobalSignal.listen('defeat', self, '_on_Defeat')
	GlobalSignal.listen('advance_stage', self, '_on_Advance_stage')

func _on_Victory(data):
	screen.show()
	victory_modal.show()

func _on_Defeat(data):
	screen.show()
	defeat_modal.show()

func _on_Advance_stage():
	hide_modals()
	screen.hide()

func hide_modals():
	victory_modal.hide()
	defeat_modal.hide()