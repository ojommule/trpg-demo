@tool
extends Node2D
class_name Cursor

# We'll use signals to keep the cursor detached from other nodes

# Emitted when clicking on the currently hovered cell or when pressing "ui_accept"
signal accept_pressed(cell)

# Emitted when the cursor moved to a new cell
signal moved(new_cell)

@export var grid: Resource = preload("res://Grid.tres")
# Time before the cursor can move again in seconds
@export var ui_cooldown := 0.1
@onready var _timer: Timer = $Timer

# Coords of current cell cursor is hovering over
var cell := Vector2.ZERO :
	set(value):
		# first we clamp the cell coords and ensure we aren't trynna move out of bounds
		var new_cell : Vector2 = grid.glamp(value)
		if new_cell.is_equal_approx(cell):
			return
		cell = new_cell
		# if we move to a new cell we update the cursor position, emit a signal, and start the cooldown timer
		position = grid.calculate_map_position(cell)
		emit_signal("moved",cell)
		_timer.start()

# When the cursor enters the scene tree we snap its position to the center of the cell and initialise the timer
func _ready():
	_timer.wait_time = ui_cooldown
	position = grid.calculate_map_position(cell)

func _unhandled_input(event):
	# if the user moves the mouse, we capture that input and update the node's cell in priority
	if event is InputEventMouseMotion:
		self.cell = grid.calculate_grid_coordinates(event.position)
	# if we are already hovering the cell and then click on it, or press the enter key, the player wants to interact
	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		# in that case, emit a signal and let another node handle the input. that is the game board's responsibility
		emit_signal("accept_pressed", cell)
		get_viewport().set_input_as_handled()
	
	# Cursor movement
	var should_move : bool = event.is_pressed()
	# if the player is pressing a key in this frame we allow cursor movement. if they keep holding the key down, we only want movement after the timer stops
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()
	if not should_move:
		return
	
	if event.is_action_pressed("ui_right"):
		self.cell += Vector2.RIGHT
	elif event.is_action_pressed("ui_left"):
		self.cell += Vector2.LEFT
	elif event.is_action_pressed("ui_up"):
		self.cell += Vector2.UP
	elif event.is_action_pressed("ui_down"):
		self.cell += Vector2.DOWN

# Draw a little outline
func _draw():
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.BLUE, false, 2.0)

