extends Node2D
class_name GameBoard

@export var grid: Resource = preload("res://Grid.tres")
@onready var _unit_overlay : UnitOverlay = $UnitOverlay
@onready var _unit_path : UnitPath = $UnitPath

const DIRECTIONS = [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]
# Dictionary to keep track of the units on the board, key is position in grid coords, value is unit reference
var _units = {}
var _active_unit : Unit
var _walkable_cells = []

func _ready():
	_reinitialize()

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

# Selects the unit in the cell if there is one, sets it active, draws the walkable cells and interactive move path
func _select_unit(cell: Vector2):
	if not _units.has(cell):
		return
	
	# when selecting a unit we turn on the overlay and path drawing
	_active_unit = _units[cell]
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)

# deselects the active unit, clearing overlay and path drawing
func _deselect_active_unit():
	_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()

func _clear_active_unit():
	_active_unit = null
	_walkable_cells.clear()

# updates the dictionary with the target position and asks the unit to walk there
func _move_active_unit(new_cell: Vector2):
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
	
	# when moving a unit, we need to update the dictionary, even if the unit takes time to get to the target cell
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	# we also deselect it
	_deselect_active_unit()
	# then we ask the unit to walk along the path stored in UnitPath and wait for the unit to finish moving
	_active_unit.walk_along(_unit_path.current_path)
	await _active_unit.walk_finished
	# finally clear the active unit and walkable cells array
	_clear_active_unit()

# selects or moves a unit based on where the cursor is
func _on_cursor_accept_pressed(cell):
	# the cursor's "accept_pressed" means the player wants to interact, either selecting a unit or ordering a move
	if not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected:
		_move_active_unit(cell)

# updates the interactive path's drawing if there's an active selected unit
func _on_cursor_moved(new_cell):
	# when the cursor moves and we already have an active unit selected, we want to update the path drawing
	if _active_unit and _active_unit.is_selected:
		_unit_path.draw(_active_unit.cell, new_cell)

func _unhandled_input(event):
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()
