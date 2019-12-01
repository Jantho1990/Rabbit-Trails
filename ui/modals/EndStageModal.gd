extends Control

onready var victory_modal = $VictoryModal
onready var defeat_modal = $DefeatModal
onready var screen = $Screen

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_modals()
	screen.hide()
#	GlobalSignal.listen('victory', self, '_on_Victory')
#	GlobalSignal.listen('defeat', self, '_on_Defeat')
	GlobalSignal.listen('end_stage', self, '_on_End_stage')
	GlobalSignal.listen('advance_stage', self, '_on_Advance_stage')

func _on_End_stage(data):
	screen.show()
	var passing_score = data.passing_score
	var rabbits_captured = Rabbits.rabbits_captured
	var rabbits_dead = Rabbits.rabbits_dead
	var budget_remaining = Budget.money
	var time_elapsed = data.time_elapsed
	var total_score = Score.calculate_score(rabbits_captured, rabbits_dead, budget_remaining, time_elapsed)
	if total_score >= passing_score:
		victory_modal.show()
		GlobalSignal.dispatch('victory', { 'next_stage': data.next_stage })
	else:
		defeat_modal.show()
		GlobalSignal.dispatch('defeat', {})

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