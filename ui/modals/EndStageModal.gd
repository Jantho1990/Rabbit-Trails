extends Control

onready var victory_modal = $VictoryModal
onready var defeat_modal = $DefeatModal

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_modals()
	GlobalSignal.listen('victory', self, '_on_Victory')
	GlobalSignal.listen('defeat', self, '_on_Defeat')
	GlobalSignal.listen('advance_stage', self, '_on_Advance_stage')

func _on_Victory(data):
	victory_modal.show()

func _on_Defeat(data):
	defeat_modal.show()

func _on_Advance_stage():
	hide_modals()

func hide_modals():
	victory_modal.hide()
	defeat_modal.hide()