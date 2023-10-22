# Signals
## Walk Finished
Emitted when the unit has reached the end of the path
# Variables
### skin
The unit's texture. When set
	skin = value that's set
	if there's not a sprite loaded in yet then wait for one (self.ready)
	then it sets the Sprite2d texture to value
### skin offset
Exclusively for the shadow of the sprite to land below the sprite and be adjustable
### cell
Coordinates of the grid's cell that the unit is on, glamped
### _is walking?_
Toggles processing for the unit
## is selected?
Toggles the selected animation
# Functions
## _Ready_
Called when ready iidk
	Prevents process from ticking
	Initializes the [[#cell]] with [[Grid#Calculate Grid Coordinates|grid coordinates]] of position and
	Sets position to the center of the cell with [[Grid#Calculate Map Position|map position]] 
	Creates a blank curve2d
## Walk Along
Given an array of vector2s of each cell along the path, starts the walking action along that path
	If the path is empty, return
	Adds a zero point to the curve2d
	For each vector2 in the path:
		calculates the center point of the cell with [[Grid#Calculate Map Position|map position]], taking out the current unit's position
		adds that point to the curve
	Sets the current cell to the last cell in the path
	Sets [[#is walking?]] to true to initiate actual sprite movement
## _Process_
Called when [[#is walking?]] is set to true
	Adds the move speed times the frame rate to the path progress, moving the sprite along the path from [[#Walk Along]]
	If the path progress is 100% done
		set [[#is walking?]] to false
		set the path progress to 0
		set the position of the unit to the [[Grid#Calculate Map Position|center point]] of the last cell of the path, ie the destination
		empty the path
		emit the [[#Walk Finished]] signal