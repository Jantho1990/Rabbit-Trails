extends HBoxContainer

var stage_time : int = 0

onready var stats_container = $CenterContainer/VBoxContainer/StatContainer
onready var total_score_node = $CenterContainer/VBoxContainer/TotalScore/Content

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('stage_time_updated', self, '_on_Stage_time_updated')

func _on_Stage_time_updated(data):
	stage_time = data.time

func set_data():
	var rabbits_captured = Rabbits.rabbits_captured
	var rabbits_dead = Rabbits.rabbits_dead
	var funds_remaining = Budget.money
	var time_spent = stage_time
	
	var captured_score = Score.calculate_rabbits_captured_score(rabbits_captured)
	var dead_score = Score.calculate_rabbits_dead_score(rabbits_dead)
	var funds_score = Score.calculate_budget_remaining_score(funds_remaining)
	var time_score = Score.calculate_time_elapsed_score(time_spent)
	var final_score = Score.calculate_score(rabbits_captured, rabbits_dead, funds_remaining, time_spent)
	
	stats_container.get_node('RabbitsCaptured').set_content(captured_score)
	stats_container.get_node('RabbitsDead').set_content(dead_score)
	stats_container.get_node('BudgetRemaining').set_content(funds_score)
	stats_container.get_node('TimeElapsed').set_content(time_score)
#	breakpoint
	
	total_score_node.text = String(final_score)