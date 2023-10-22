extends TileMap
class_name UnitOverlay

func draw_walkable_cells(cells: Array):
	clear()
	var cell_array = []
	for cell in cells:
		cell_array.append(Vector2i(cell))
	set_cells_terrain_connect(0,cell_array,0,0)

func draw_attackable_cells(cells: Array):
	var cell_array  =[]
	for cell in cells:
		cell_array.append(Vector2i(cell))
	set_cells_terrain_connect(0,cell_array,0,1)
