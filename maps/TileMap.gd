extends TileMap

onready var dimensions = calculate_dimensions()

func _init():
	pass
	#collision_layer = 2 # 2 is the environment later, setting here because I don't want to update for every individual tilemap

func _ready():
	generate_collision_areas()

# Thanks to https://godotengine.org/qa/7450/how-do-i-get-tilemaps-size-height-and-width-with-script
func calculate_dimensions():
	# Get list of all positions where there is a tile
	var used_cells = self.get_used_cells()

	# If there are none, return null result
	if used_cells.size() == 0:
		return {x=0, y=0, width=0, height=0}

	# Take first cell as reference
	var min_x = used_cells[0].x
	var min_y = used_cells[0].y
	var max_x = min_x
	var max_y = min_y

	# Find bounds
	for i in range(1, used_cells.size()):
		var pos = used_cells[i]

		if pos.x < min_x:
			min_x = pos.x
		elif pos.x > max_x:
			max_x = pos.x

		if pos.y < min_y:
			min_y = pos.y
		elif pos.y > max_y:
			max_y = pos.y

	# Return resulting bounds
	return {
		x = min_x * self.cell_size.x,
		y = min_y * self.cell_size.y,
		width = (max_x - min_x + 1) * self.cell_size.x,
		height = (max_y - min_y + 1) * self.cell_size.y,
		cells = {
	        x = min_x,
	        y = min_y,
	        width = max_x - min_x + 1,
	        height = max_y - min_y + 1,
			count = used_cells.size()
		}
    }

# Get tile at specified position vector
func tile_at_pos(pos):
	var tile = world_to_map(pos)
	return Vector2(tile.x, tile.y)

# Get tile above the tile at specified position vector
func tile_above_pos(pos):
	var tile = world_to_map(pos)
	return Vector2(tile.x, tile.y - 1)

# Get tile below the tile at specified position vector
func tile_below_pos(pos):
	var tile = world_to_map(pos)
	return Vector2(tile.x, tile.y + 1)

# Get tile left of the tile at specified position vector
func tile_left_pos(pos):
	var tile = world_to_map(pos)
	return Vector2(tile.x - 1, tile.y)

# Get tile right of the tile at specified position vector
func tile_right_pos(pos):
	var tile = world_to_map(pos)
	return Vector2(tile.x + 1, tile.y)

# Get the tiles around specified position vector.
func tiles_around_pos(pos):
	var tile = world_to_map(pos)
	return {
		"above": Vector2(tile.x, tile.y - 1),
		"below": Vector2(tile.x, tile.y + 1),
		"left": Vector2(tile.x - 1, tile.y),
		"right": Vector2(tile.x + 1, tile.y),
		"aboveLeft": Vector2(tile.x - 1, tile.y - 1),
		"aboveRight": Vector2(tile.x + 1, tile.y - 1),
		"belowLeft": Vector2(tile.x - 1, tile.y + 1),
		"belowRight": Vector2(tile.x + 1, tile.y + 1)
	}

# Get a random cell from the tilemap
func random_cell(config = {}):
	var _range
	if not config.has("range"):
		_range = {
			"x": {
				"lower": 0,
				"upper": dimensions.width
			},
			"y": {
				"lower": 0,
				"upper": dimensions.height
			}
		}
	else:
		_range = config.range
		
	var x = math.rand(_range.x.lower, _range.x.upper) + dimensions.x
	var y = math.rand(_range.y.lower, _range.y.upper) + dimensions.y
	return world_to_map(Vector2(x, y))

func random_cell_pos():
	return map_to_world(random_cell())

# Map a grid of Area2Ds and position them over the tilemap.
# This is necessary for collision detection because Area2Ds
# do not collide with TileMaps, so we need our own way to
# detect when collision happens with the map.
var collision_area_container
func generate_collision_areas():
	if collision_area_container:
		return
	
	collision_area_container = Node2D.new()
	var used_cells = get_used_cells()
#	print(tile_set.tile_get_shape_count(0))
#	for shape in tile_set.tile_get_shapes(0):
#		print(shape)
#	print(tile_set.tile_get_shapes(0), tile_set.get_tiles_ids())
	
	for i in range(0, used_cells.size() - 1):
		var cell = used_cells[i]
#		var cell = world_to_map(pos)
		var above = Vector2(cell.x, cell.y - 1)
		var below = Vector2(cell.x, cell.y + 1)
		if get_cell(above.x, above.y) == INVALID_CELL and \
			get_cell(cell.x, cell.y) == 0:
				continue
		var area2d = preload('res://maps/TilemapCollisionArea.tscn').instance()
#		var collision = CollisionShape2D.new()
#		var shape = RectangleShape2D.new()
#		shape.extents = Vector2(32, 32)
#		collision.shape = shape
#		area2d.add_child(collision)
		area2d.position = (cell * cell_size) + cell_size / 2
		area2d.tile_map = self
		collision_area_container.add_child(area2d)
	
	add_child(collision_area_container)