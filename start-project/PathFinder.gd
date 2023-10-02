extends Resource
class_name PathFinder

const DIRECTIONS = [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]

var _grid : Resource

# This variable holds the AStar2D instance that will do the pathfinding
var _astar := AStar2D.new()

# Initializes AStar upon creation, passing the data it needs from the Unit script it will start with
func _init(grid: Grid, walkable_cells: Array):
	_grid = grid
	# To create the AStar graph we need the index values corresponding to each grid cell
	# We cache a mapping between cell coordinates and their unique index to improve performance
	var cell_mappings := {}
	for cell in walkable_cells:
		# for each cell we define a key-value pair of cell coordinates, the index
		cell_mappings[cell] = _grid.as_index(cell)
	# we then add all the cells to our AStar instance and connect them to create the pathfinding graph
	_add_and_connect_points(cell_mappings)

# Returns the path found between 'start' and 'end' as an array of Vector2 coords
func calculate_point_path(start: Vector2, end: Vector2) -> PackedVector2Array:
	var start_index: int = _grid.as_index(start)
	var end_index: int = _grid.as_index(end)
	if _astar.has_point(start_index) and _astar.has_point(end_index):
		return _astar.get_point_path(start_index,end_index)
	else:
		return PackedVector2Array()

func _add_and_connect_points(cell_mappings: Dictionary):
	# First we register all our points in the Astar graph
	# We pass each cell's unique index and the corresponding Vector2 coords to the AStar
	for point in cell_mappings:
		_astar.add_point(cell_mappings[point], point)
	# Then we loop over the points again, connect them all with their neighbors using another function to find the neighbors
	for point in cell_mappings:
		for neighbor_index in _find_neighbor_indices(point, cell_mappings):
			_astar.connect_points(cell_mappings[point], neighbor_index)

func _find_neighbor_indices(cell: Vector2, cell_mappings: Dictionary) -> Array:
	var out := []
	# To find neighbors, we try to move one cell in every possible direction and ensure it is walkable and not already connected
	for direction in DIRECTIONS:
		var neighbor: Vector2 = cell + direction
		# must be walkable
		if not cell_mappings.has(neighbor):
			continue
		# must account for selecting the same cells more than once
		if not _astar.are_points_connected(cell_mappings[cell], cell_mappings[neighbor]):
			out.push_back(cell_mappings[neighbor])
	return out
