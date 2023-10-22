Uses AStar to handle pathfinding
# Functions
## _Init_
Given a [[Grid]] and an array of [[Combat Board#Get Walkable Cells|walkable cells]]
	creates a dictionary of cells such that
	for every cell in the array
		adds the vector value of the cell to the dictionary under it's unique [[Grid#As Index|index value]] on the grid
	[[#Add and Connect Points|adds]] the cells together into an AStar path
## _Find Neighbor Indices_
Given an input cell and a dictionary of cell indices and their vector values
	make a list
	for every direction up, down, left, and right:
		neighbor is cell + direction
		if cell dictionary doesn't already have new neighbor cell, continue for loop
		if AStar can't connect an already existing cell to this neighbor
			add it to the end of the list
	return the list of the input cell's neighbors
## _Add and Connect Points_
Given a dictionary of cell indices and their vector values
	adds all the cell points in the dictionary to the AStar algorithm
	then for each cell point, connects neighbors using [[#Find Neighbor Indices]] into one path
## Calculate Point Path
Given start and end vectors
	converts them to [[Grid#As Index|indices]] 
	if AStar currently has the points that those indices represent on its path
		return all the points on the path from start to end as an array of vectors
	otherwise return an empty vector array to avoid errors