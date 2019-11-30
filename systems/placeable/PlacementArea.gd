extends Area2D

signal snap_placement

enum placement_types { AIR, GROUND, WALL }
export(placement_types) var placement_type

export(float) var grace_range = 5.00

export(bool) var snap_placement = false

const UP = Vector2(0, -1)

var placement_valid = true

var collisions_updated = false

var snap_location = position

onready var parent = get_parent().get_parent()
onready var placeable = get_parent()

func _ready():
	connect('body_entered', self, '_on_Body_entered')
	connect('body_exited', self, '_on_Body_exited')
	match placement_type:
		placement_types.GROUND, placement_types.WALL:
			placement_valid = false

func _physics_process(delta):
#	GlobalSignal.dispatch('debug_label', { 'text': 'Allowed to move: ' + String(placeable.allowed_to_move)})
	position = owner.position
#	position = parent.position
	collisions_updated = false
#	print(get_overlapping_areas())
	if placeable.allowed_to_move:
		for area in get_overlapping_areas():
			handle_placement_validation(area, 'update')
		for body in get_overlapping_bodies():
			handle_placement_validation(body, 'update')
		collisions_updated = true
	if placement_valid and snap_placement and placeable.allowed_to_move:
		emit_signal('snap_placement', snap_location)
#		GlobalSignal.dispatch('debug_label', { 'text': 'valid snap' })
	update()

func _on_PlacementArea_area_entered(area):
#	GlobalSignal.dispatch('debug_label', { 'text': area is TilemapCollisionArea })
	handle_placement_validation(area, 'enter')
#	if area is TilemapCollisionArea:
#		placement_valid = false

func _on_Body_entered(body):
	handle_placement_validation(body, 'enter')

func _on_Body_exited(body):
	handle_placement_validation(body, 'exit')

func _draw():
#	GlobalSignal.dispatch('debug_label', { 'text': placement_valid })
	
	if not placeable.allowed_to_move:
		return
#	GlobalSignal.dispatch('debug_label', { 'text': String(position) })
	var collision_shape = get_node('CollisionShape2D').shape
	var placement_color = Color(0, 1, 0, 0.5) if placement_valid else Color(1, 0, 0, 0.5)
	if collision_shape is CircleShape2D:
		draw_circle(Vector2(0, 0), collision_shape.radius, placement_color) # +6 = safe_margin
	elif collision_shape is RectangleShape2D:
#		var ext = owner.get_node(NodePath('CollisionArea/CollisionShape2D')).shape.extents
		var ext = collision_shape.extents
		var draw_offset 
		if placement_valid and snap_placement:
			draw_offset = position - snap_location + Vector2(0, collision_shape.extents.y / 2)
		else:
			draw_offset = Vector2(0, 0)
		var rec = Rect2(Vector2(0, 0) - Vector2(ext.x, ext.y) - draw_offset, ext * 2)
#		GlobalSignal.dispatch('debug_label', { 'text': rec })
		draw_rect(rec, placement_color, true)
	elif collision_shape is ConvexPolygonShape2D:
		var points = collision_shape.points
		draw_colored_polygon(points, placement_color)

func _on_PlacementArea_area_exited(area):
	handle_placement_validation(area, 'exit')
	if area is TilemapCollisionArea:
		area.tile_color = Color(1, 1, 0, 0.25)
#	if area is TilemapCollisionArea:
#		placement_valid = true

func handle_placement_validation(area, type = null):
	if area.name == 'SelectionArea' or \
		area.name == 'PlacementArea' or \
		area.get_parent() == parent:
			return
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
			if area is TilemapCollisionArea or area.get_parent() is Gizmo:
				placement_valid = true
		_:
			if area.get_parent() is Gizmo:
				placement_valid = false
			
			if area is TilemapCollisionArea:
				placement_valid = false

func validate_placement_ground(area, type):
	match type:
		'enter', 'update':
			if area.get_parent() is Gizmo:
				placement_valid == false
			elif area is TilemapCollisionArea:
				var tile_map = area.tile_map
				area.tile_color = Color(1, 1, 1, 0.25)
				var above = tile_map.tile_above_pos(area.position)
				var above2 = Vector2(above.x, above.y - 1)
				if tile_map.get_cell(above2.x, above2.y) == -1 and \
					tile_map.get_cell(above.x, above.y) == 0:
						placement_valid = true
						if snap_placement:
							snap_location = Vector2(position.x, tile_map.map_to_world(above).y + tile_map.cell_size.y - 1)
						return
				else:
					placement_valid = false
		'exit':
			if area is TilemapCollisionArea or area.get_parent() is Gizmo:
				placement_valid = false

func validate_placement_wall(area, type):
	match type:
		'enter', 'update':
			if area.get_parent() is Gizmo:
				placement_valid = false
			elif area is TilemapCollisionArea:
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
			if area is TilemapCollisionArea or area.get_parent() is Gizmo:
				placement_valid = false