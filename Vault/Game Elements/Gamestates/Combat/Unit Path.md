Contains single tilemap node to display the path of the [[Combat Board#Select Unit|selected unit]] as an arrow that points from the [[Unit|unit]] to the [[Combat Board#Walkable Cells|chosen cell]] as selected by the [[Cursor|cursor]]


# Functions

## Initialize
Initialize creates a [[Pathfinder]] object and gives it the current [[Grid]] and [[Combat Board#Walkable Cells|an array of cells]]
## Draw
Draw takes a start and end cell
	clears the tiles
	makes the path between those cells with [[Pathfinder#Calculate Point Path|calculate_point_path]] 
	updates the tiles to use the 0th terrain of parent node, the arrows
## Stop
Stop empties the pathfinder and clears the board