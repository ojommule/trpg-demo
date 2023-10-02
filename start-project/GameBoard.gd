extends Node2D
class_name GameBoard

const DIRECTIONS = [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]
@export var grid: Resource = preload("res://Grid.tres")
@onready var _unit_overlay : UnitOverlay = $UnitOverlay

# Dictionary to keep track of the units on the board, key is position in grid coords, value is unit reference
var _units = {}

func _reinitialize():
	_units.clear()
	# loop over the node's children and filter them to find units. node group feature might help (idk what that is)
	for child in get_children():
		# as keyword selects only Units
		var unit := child as Unit
		if not unit:
			continue
		_units[unit.cell] = unit

func is_occupied(cell: Vector2) -> bool:
	return true if _units.has(cell) else false

func _ready():
	_reinitialize()

func _flood_fill(cell: Vector2, max_distance: int) -> Array:
	var array = []
	# in a stack we store every cell we want to apply the flood fill algorithm to
	var stack = [cell]
	# then we loop over cells in the stack
	while not stack.is_empty():
		# removes and returns the last item
		var current = stack.pop_back()
		# for each cell we try to fill further, so long as
		# 1. we didnt go past the grid limits
		# 2. we haven't already filled this cell
		# 3. we are within the unit's max_distance
		if not grid.is_within_bounds(current):
			continue
		if current in array:
			continue
		
		# now check for distance between starting cell and current cell
		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue
		
		# all conditions met, then fill the current cell by storing it in array
		array.append(current)
		# now look at neighbors. if they aren't occupied and we havent visited them already, add them to the stack
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if is_occupied(coordinates):
				continue
			if coordinates in array:
				continue
			stack.append(coordinates)
	return array

func get_walkable_cells(unit: Unit) -> Array:
	return _flood_fill(unit.cell,unit.move_range)
