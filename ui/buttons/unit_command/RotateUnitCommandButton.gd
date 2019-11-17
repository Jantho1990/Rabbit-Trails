extends UnitCommandButton

# Called when the node enters the scene tree for the first time.
func _ready():
	deactivate_button()
	Selection.register_listener('select', self, '_on_Selection')
	Selection.register_listener('deselect', self, '_on_Deselection')

func _exit_tree():
	Selection.unregister_listener('select', self, '_on_Selection')
	Selection.unregister_listener('deselect', self, '_on_Deselection')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Selection.has_selection():
#		visible = true
#	else:
#		visible = false

func _on_Selection(selected_entity, __throwaway__):
	if 'direction' in selected_entity:
		activate_button()

func _on_Deselection(__throwaway__):
	if visible:
		deactivate_button()
