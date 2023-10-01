class_name Grid
extends Resource

# Grid size in rows and columns
@export var size := Vector2(20,20)
# Cell size in pixels
@export var cell_size := Vector2(80,80)

# Half cell size is used to calculate the center of a grid in pixels to place units
var _half_cell_size = cell_size / 2

# Returns center point vector of a cell in pixels
func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + _half_cell_size

# Returns coordinates of a cell on the grid given a position on the map
func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()

# We place units in editor, calculate_grid_coordinates finds where they are and 
# calculate_map_position snaps them to the grid

# Returns true if cell_coordinates are within the grid so you can't place units out of bounds
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y

# Makes grid_position fit within the bounds
func glamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0 ,size.y - 1.0)
	return out

# Given Vector2 coordinates, returns integer index
# Effectively converts 2D coordinates to 1D array indices
# Useful to make AStar pathfinding optimal for large maps
func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)
