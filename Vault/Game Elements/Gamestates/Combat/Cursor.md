# Variables
## Cell
Coords of the current cell the cursor is hovering over
When set
	[[Grid#Glamp|glamp]] the cell
	~if nothing really happened, return
	set the current cell to the glamped cell
	and set the cursor position to the [[Grid#Calculate Map Position|center of the cell]]
	emit the [[#Moved]] signal
	and start the timer object
# Signals

## Accept Pressed
Emitted when the currently hovered over cell is clicked on
## Moved
Emitted when the cursor is moved to a new cell

# Functions

## _Draw_
Draws a little square
## _Unhandled Input_
Given unhandled event
	If the user moves the mouse
		set the cursor [[#Cell]] equal to the [[Grid#Calculate Grid Coordinates|grid coords]] of the position of the mouse
	Otherwise if the event is a mouse click or an "accept" input
		emit the [[#Accept Pressed]] signal
		declare the input event as handled
	
## _Ready_
Sets the timer's wait time and sets the cursor to start at the center of whatever cell it's nearest via [[Grid#Calculate Map Position|grid.calculate_map_position]]
