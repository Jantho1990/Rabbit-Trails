extends HBoxContainer

class_name FundsBar

onready var display = $StatBarDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('budget_updated', self, '_on_Budget_updated')
	GlobalSignal.listen('budget_set', self, '_on_Budget_set')
	GlobalSignal.listen('budget_reset', self, '_on_Budget_reset')
	GlobalSignal.listen('unit_cannot_afford', self, '_on_Unit_cannot_afford')

func _on_Budget_reset():
	set_budget_display(0)

func _on_Budget_set(data):
	var money = data.value
	set_budget_display(money)

func _on_Budget_updated(data):
	var money = data.money
	set_budget_display(money)

func _on_Unit_cannot_afford(data):
	display.flash_danger(3)

func set_budget_display(value):
	display.set_value(value)