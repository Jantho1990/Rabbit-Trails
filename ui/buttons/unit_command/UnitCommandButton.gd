extends TextureButton

class_name UnitCommandButton

export(String) var command_name
export(String, '', 'Q', 'W', 'E', 'A', 'S', 'D', 'Z', 'X', 'C') var command_card_key
export(bool) var allow_auto_activate = true

var hovering = false

const SHOW_COLOR = Color(1, 1, 1, 1)
const HIDE_COLOR = Color(1, 1, 1, 0)

var flash_time = 0.2
var flash_delay = 0.4

onready var command_card = owner
onready var hover_color = $HoverColor
onready var tween = $FlashTween

# Called when the node enters the scene tree for the first time.
func _ready():
	connect('pressed', self, '_on_UnitCommandButton_pressed')
	hover_color.modulate = HIDE_COLOR
	connect('mouse_entered', self, '_on_Mouse_entered')
	connect('mouse_exited', self, '_on_Mouse_exited')
	hover_color.connect('mouse_entered', self, '_on_Mouse_entered')
	hover_color.connect('mouse_exited', self, '_on_Mouse_exited')
	
	tween.connect('tween_all_completed', self, '_on_Tween_all_completed')
	
	GlobalSignal.listen('flash_button', self, '_on_Flash_button')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Selection.has_selection():
#		visible = true
#	else:
#		visible = false

func _input(event):
	if event is InputEventKey and \
		event.is_action('command_card_key'):
			if char(event.scancode) == command_card_key:
				GlobalSignal.dispatch('unit_command', { 'command_name': command_name })
			else:
				print('1: ', char(event.scancode), ', 2:', command_card_key)

func _on_Flash_button(data):
	if data.button_name == name:
		var times = data.flash_times if data.has('flash_times') else 3
		flash(times)

func _on_Mouse_entered():
	start_hover()

func _on_Mouse_exited():
	stop_hover()

func start_hover():
	if tween.is_active(): # Button is being flashed.
		return
	hovering = true
	hover_color.modulate = SHOW_COLOR

func stop_hover():
	if tween.is_active(): # Button is being flashed.
		return
	hovering = false
	hover_color.modulate = HIDE_COLOR

func _on_Tween_all_completed():
	stop_hover()

func _on_UnitCommandButton_pressed():
	GlobalSignal.dispatch('unit_command', { 'command_name': command_name })

func deactivate_button():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
	print(name, ' deactivated')

func deactivate():
	if allow_auto_activate:
		deactivate_button()

func activate_button():
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
	print(name, ' activated')

func activate():
	if allow_auto_activate:
		activate_button()

func flash(times = 1):
	if tween.is_active():
		reset_tween()
	if hovering:
		stop_hover()
	for i in range(0, times * 2, 2):
		tween.interpolate_property(hover_color, 'modulate', HIDE_COLOR, SHOW_COLOR, flash_time, Tween.TRANS_LINEAR, Tween.EASE_IN, flash_delay * i)
		tween.interpolate_property(hover_color, 'modulate', SHOW_COLOR, HIDE_COLOR, flash_time, Tween.TRANS_LINEAR, Tween.EASE_IN, flash_delay * (i + 1))
	tween.start()

func _on_Flash_completed():
	reset_tween()

func reset_tween():
	tween.stop_all()
	tween.remove_all()