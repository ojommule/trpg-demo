extends TileMap
class_name UnitPath

@export var grid: Resource

# Holds pathfinder reference. one is created every time we select a unit
var _pathfinder: PathFinder
# This caches a path found by the pathfinder
var current_path := PackedVector2Array()

# Creates a new pathfinder that uses the astar algorithm to find a path between two walkable cells
func initialize(walkable_cells: Array):
	_pathfinder = PathFinder.new(grid, walkable_cells)

# finds and draws the path between start and end cells
func draw(cell_start: Vector2, cell_end: Vector2):
	clear()
	var cells = []
	current_path = _pathfinder.calculate_point_path(cell_start,cell_end)
	for cell in current_path:
		cells.append(Vector2i(cell))
	set_cells_terrain_connect(0,cells,0,0)

func stop():
	_pathfinder = null
	clear()

#func _ready():
#	var rect_start := Vector2(4,4)
#	var rect_end = Vector2(10,8)
#
#	# generates the array of points filling the rectangle from start to end
#	var points = []
#	# in a loop, range is implicitely called for any "in #"
#	for x in rect_end.x - rect_start.x + 1:
#		for y in rect_end.y - rect_start.y + 1:
#			points.append(rect_start + Vector2(x,y))
#	initialize(points)
#	draw(rect_start, Vector2(8,7))
