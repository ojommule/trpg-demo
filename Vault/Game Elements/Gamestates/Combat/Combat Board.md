# Scene
Main
	Map
	[[Combat Board]] *
		[[Unit Overlay]] *
		[[Unit Path]] *
		[[Unit]] *
		[[Cursor]] *

# Functions
## _Ready_
Calls reinitialize
## _Reinitialize_
Finds the [[Unit|units]] in the tree and organizes them in a dictionary
	empties the units dictionary
	loops over children in scene tree, for child in children:
		unit = child **as** Unit, where the **as** sets objects that aren't Units to be null
		if the unit is null continue to the next object in the tree
		add the confirmed unit to the dictionary, where the index is grid position and the value is the reference to the unit
## Is Occupied?
Given a cell vector2, returns true if the unit dictionary has a unit in that cell, otherwise returns false
## _Flood Fill_
Given a selected unit's cell and maximum move distance, returns an array of cells to be filled with yellow tiles
	Creates an empty array to return at the end
	Creates an array called the stack containing the unit's cell. we will add to and remove from it
	as long as the stack isn't empty:
		the "current" cell is the last item of the stack, and **pop_back()** removes that cell from the stack
		*there are three things we want to check for while flooding: 
		1. we're within the grid limits
		2. we haven't already filled this cell
		3. we are within the unit's maximum move distance*
		first is an easy check, if [[Grid#Is Within Bounds?|grid.is_within_bounds(current)]] returns false, skip to next item in the stack
		second is even easier, if the current cell is already in the array, skip
		third is tougher, first we gotta find the difference between the current cell and the og unit cell
		then, since that's a vector2, we add the x and y values to be the total distance
		if that distance is greater than the unit's max move distance, skip
		store the current cell in the return array and let's move on to neighbors
		for each cardinal vector2 direction:
			the new cell is the current cell + one of the directions
			if that new cell [[#Is Occupied?]] then skip
			if that new cell is already in the return array then skip
			add it to the return array
	return the array
## Get Walkable Cells
## _Select Unit_
## _Deselect Active Unit_
## _Clear Active Unit_
## _Move Active Unit_
## _On Cursor Accept Pressed_
## _On Cursor Moved_
## _Unhandled Input_