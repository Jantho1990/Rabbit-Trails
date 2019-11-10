extends Area2D

enum placement_types { AIR, GROUND, WALL }
export(placement_types) var placement_type

export(float) var grace_range = 5.00

const UP = Vector2(0, -1)

var placement_valid = true

var collisions_updated = false

func _physics_process(delta):
	position = owner.position
	collisions_updated = false
	print(get_overlapping_areas())
	for area in get_overlapping_areas():
		if area is TilemapCollisionArea:
			print('invalid')
			breakpoint
			placement_valid = false
	collisions_updated = true
	update()

func _on_PlacementArea_area_entered(area):
	GlobalSignal.dispatch('debug_label', { 'text': area is TilemapCollisionArea })
	if area is TilemapCollisionArea:
		placement_valid = false

func _draw():
#	GlobalSignal.dispatch('debug_label', { 'text': String(position) })
	var placement_color = Color(0, 1, 0, 0.5) if placement_valid else Color(1, 0, 0, 0.5)
	draw_circle(Vector2(0, 0), 50, placement_color) # +6 = safe_margin

func _on_PlacementArea_area_exited(area):
	if area is TilemapCollisionArea:
		placement_valid = true
