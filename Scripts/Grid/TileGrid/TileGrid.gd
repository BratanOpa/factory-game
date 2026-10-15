class_name TileGrid

var grid: Array = []

func _init(width: int, height: int) -> void:
	create_grid(width, height)

func create_grid(width: int, height: int) -> void:
	grid.resize(height) # Creates Y rows
	for y in range(height):
		var row = []
		row.resize(width) # Creates X columns
		for x in range(width):
			row[x] = Tile.new()
		grid[y] = row # Add X columns
