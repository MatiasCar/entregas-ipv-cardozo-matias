extends TileMap
class_name PathfindAstar

# You can only create an AStar node from code, not from the Scene tab
onready var astar_node: AStar2D = AStar2D.new()

onready var map_limits: Rect2 = get_used_rect()

const BASE_LINE_WIDTH: float = 3.0
const DRAW_COLOR: Color = Color('#fff')

# get_used_cells_by_id is a method from the TileMap node
# here the id 0 corresponds to the grey tile, the obstacles
onready var walkable_cells: Array = get_used_cells_by_id(0)
onready var _half_cell_size: Vector2 = cell_size / 2

func _ready():
	var walkable_cells_list: Array = astar_add_walkable_cells(walkable_cells)
	astar_connect_walkable_cells_diagonal(walkable_cells_list)
	hide()

# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles
func astar_add_walkable_cells(walkable_cells = []) -> Array:
	var points_array = []
	for y in range(map_limits.position.y, map_limits.end.y):
		for x in range(map_limits.position.x, map_limits.end.x):
			var point = Vector2(x, y)
			if point in walkable_cells:
				points_array.append(point)
				# The AStar class references points with indices
				# Using a function to calculate the index from a point's coordinates
				# ensures we always get the same index with the same input point
				var point_index = calculate_point_index(point)
				# AStar works for both 2d and 3d, so we have to convert the point
				# coordinates from and to Vector3s
				astar_node.add_point(point_index, point)
	return points_array


# Once you added all points to the AStar node, you've got to connect them
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like
# It's a little harder to code at first, but works for 2d, 3d,
# orthogonal grids, hex grids, tower defense games...
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstacle,
		# We connect the current point with it
		var points_relative = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)

			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			# Note the 3rd argument. It tells the astar_node that we want the
			# connection to be bilateral: from point A to B and B to A
			# If you set this value to false, it becomes a one-way path
			# As we loop through all points we can set it to false
			astar_node.connect_points(point_index, point_relative_index, false)


# This is a variation of the method above
# It connects cells horizontally, vertically AND diagonally
func astar_connect_walkable_cells_diagonal(points_array: Array) -> void:
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = calculate_point_index(point_relative)

				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not astar_node.has_point(point_relative_index):
					continue
				astar_node.connect_points(point_index, point_relative_index, true)


func is_outside_map_bounds(point: Vector2) -> bool:
	return !map_limits.has_point(point)


func calculate_point_index(point: Vector2) -> int:
	var relative_point: Vector2 = point - map_limits.position
	return int(relative_point.y * map_limits.size.x + relative_point.x)


func is_valid_node(point: Vector2) -> bool:
	return astar_node.has_point(calculate_point_index(world_to_map(to_local(point))))


func get_simple_path(world_start: Vector2, world_end: Vector2) -> Array:
	var path_start_position = world_to_map(to_local(world_start))
	
	var world_to_map_end:Vector2 = world_to_map(to_local(world_end))
	var closest_point_id = astar_node.get_closest_point(world_to_map_end)
	if closest_point_id == -1:
		return []
	var closest_point_vector3 = astar_node.get_point_position(closest_point_id)
	
	var path_end_position = Vector2(closest_point_vector3.x, closest_point_vector3.y)
	if not path_start_position in walkable_cells || not path_end_position in walkable_cells:
		return []
	if is_outside_map_bounds(path_start_position) || is_outside_map_bounds(path_end_position):
		return []
		
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	var _point_path = astar_node.get_point_path(start_point_index, end_point_index)
	
	var path_world = []
	for point in _point_path:
		var point_world = to_global(map_to_world(Vector2(point.x, point.y)) + _half_cell_size)
		path_world.append(point_world)
	return path_world
