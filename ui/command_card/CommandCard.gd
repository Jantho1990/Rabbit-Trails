extends Control

onready var build_card = get_node('MarginContainer/BuildCommandCard')
onready var unit_card = get_node('MarginContainer/UnitCommandCard')

# Called when the node enters the scene tree for the first time.
func _ready():
	Selection.register_listener('select', self, '_on_Selection')
	Selection.register_listener('clear', self, '_on_Clear_selection')
	GlobalSignal.listen('delete_unit', self, '_on_Delete_unit')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_build_card():
	build_card.activate_tree()
	unit_card.deactivate_tree()

func show_unit_card():
	unit_card.activate_tree()
	build_card.deactivate_tree()

func _on_Clear_selection(__throwaway__):
	show_build_card()
	print('show build card')

func _on_Selection(__throwaway__, __throwaway2__):
	show_unit_card()
	print('show unit card')

func _on_Delete_unit():
	show_build_card()