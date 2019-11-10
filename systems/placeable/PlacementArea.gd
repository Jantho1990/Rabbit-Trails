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
#	print(get_overlapping_areas())
	for area in get_overlapping_areas():
		handle_placement_validation(area, 'update')
#		if area is TilemapCollisionArea:
#			print('invalid')
#			placement_valid = false
	collisions_updated = true
	update()

func _on_PlacementArea_area_entered(area):
#	GlobalSignal.dispatch('debug_label', { 'text': area is TilemapCollisionArea })
	handle_placement_validation(area, 'enter')
#	if area is TilemapCollisionArea:
#		placement_valid = false

func _draw():
#	GlobalSignal.dispatch('debug_label', { 'text': String(position) })
	var collision_shape = get_node('CollisionShape2D').shape
	var placement_color = Color(0, 1, 0, 0.5) if placement_valid else Color(1, 0, 0, 0.5)
	if collision_shape is CircleShape2D:
		draw_circle(Vector2(0, 0), 50, placement_color) # +6 = safe_margin
	elif collision_shape is RectangleShape2D:
		draw_rect(Rect2(Vector2(-25, -50), Vector2(50, 100)), placement_color, true)

func _on_PlacementArea_area_exited(area):
	handle_placement_validation(area, 'exit')
	if area is TilemapCollisionArea:
		area.tile_color = Color(1, 1, 0, 0.25)
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
	match type:
		'update':
			if area is TilemapCollisionArea:
				var tile_map = area.tile_map
				area.tile_color = Color(1, 1, 1, 0.25)
				var above = tile_map.tile_above_pos(area.position)
				if tile_map.get_cell(above.x, above.y) == -1:
					placement_valid = true
					return
				else:
					GlobalSignal.dispatch('debug_label', {
						'text': String(area.position) + ' ' + String(above) + ' ' + String(tile_map.get_cell(above.x, above.y))
					})
					placement_valid = false

func validate_placement_wall(area, type):
	match type:
		'enter':
			continue
		'update':
			if area is TilemapCollisionArea:
				var tile_map = area.tile_map
				area.tile_color = Color(1, 1, 1, 0.25)
				var shape = get_node('CollisionShape2D').shape
				var y
				if shape is CircleShape2D:
					y = shape.radius
				elif shape is RectangleShape2D:
					y = shape.extents.y
				var tile = tile_map.tile_at_pos(Vector2(position.x, position.y + y))
#				var tile = tile_map.tile_at_pos(position)
				var left = tile_map.tile_left_pos(area.position)
				var right = tile_map.tile_right_pos(area.position)
				if tile_map.get_cell(tile.x, tile.y) == -1 and \
					(tile_map.get_cell(left.x, left.y) == 0 or \
					tile_map.get_cell(right.x, right.y) == 0):
					placement_valid = true
					return
				else:
					placement_valid = false
		'exit':
			if area is TilemapCollisionArea:
				placement_valid = false