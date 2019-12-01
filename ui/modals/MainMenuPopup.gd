extends CenterContainer

onready var main_menu_modal = $MainMenuModal
onready var options_modal = $OptionsModal
onready var modals = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_modal.set_change_menu_func(funcref(self, 'change_menu'))
	options_modal.set_back_func(funcref(self, 'options_back'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_menu(menu_name):
	for modal in modals:
		if modal.name == menu_name:
			modal.show()
		else:
			modal.hide()

func options_back():
	change_menu('MainMenuModal')