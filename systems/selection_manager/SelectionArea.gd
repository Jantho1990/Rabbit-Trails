extends Area2D

signal selection_area_triggered

var registered = false
var selected = false

# Keep track of whether the mouse is over the selection area
var mouse_over_selection_area = false

var deselect_callbacks = []

onready var parent = get_parent()

func _ready():
	parent.add_to_group("selectable_entities")
	Selection.register_entity(parent)

func _physics_process(delta):
	update()

func _draw():
	if selected:
		circle_outline(Vector2(0, 0), 70, Color(255, 0, 0))

# Runs when an entity collides with the Area2D.
func _input_event(viewport, event, shape_idx):
	if parent.has_method('allow_selection') and not parent.allow_selection():
		return
	
	if not selected and \
		event is InputEventMouseButton and \
		event.pressed and \
		event.button_index == BUTTON_LEFT:
			print("triggered")
			emit_signal("selection_area_triggered", parent)

func register_entity():
	registered = true

func circle_outline(center, radius, color):
	var points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(points + 1):
		var angle_point = deg2rad(0 + i * 360 / points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 1)

func mark_as_deselected():
	selected = false

func mark_as_selected():
	selected = true

func _on_Deselect_entity():
	print("hit callback that shouldn't be")
	mark_as_deselected()