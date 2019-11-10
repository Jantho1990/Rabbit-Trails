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
		handle_placement_validation(area)
#		if area is TilemapCollisionArea:
#			print('invalid')
#			placement_valid = false
	collisions_updated = true
	update()

func _on_PlacementArea_area_entered(area):
	GlobalSignal.dispatch('debug_label', { 'text': area is TilemapCollisionArea })
	handle_placement_validation(area, 'enter')
#	if area is TilemapCollisionArea:
#		placement_valid = false

func _draw():
#	GlobalSignal.dispatch('debug_label', { 'text': String(position) })
	var placement_color = Color(0, 1, 0, 0.5) if placement_valid else Color(1, 0, 0, 0.5)
	draw_circle(Vector2(0, 0), 50, placement_color) # +6 = safe_margin

func _on_PlacementArea_area_exited(area):
	handle_placement_validation(area, 'exit')
#	if area is TilemapCollisionArea:
#		placement_valid = true

func handle_placement_validation(area, type = null):
	match placement_type:
		placement_types.AIR:
			validate_placement_air(area, type)
		placement_types.GROUND:
			validate_placement_ground(area, type)
		placement_types.WALL:
			validate_placement_wall(area, type)

func validate_placement_air(area, type):
	match type:
		'exit':
			if area is TilemapCollisionArea:
				placement_valid = true
		_:
			if area is TilemapCollisionArea:
				print('invalid')
				placement_valid = false

func validate_placement_ground(area, type):
	pass

func validate_placement_wall(area, type):
	pass