class_name TerrainGrid

var grid: Array = []

func _init(width: int, height: int) -> void:
	create_grid(width, height)
	var ore = grid[3][5].ore
	ore = OreBehavior.new(10)
	print(ore.amount)
	ore.dig()
	ore.dig()
	ore.dig()
	ore.dig()
	ore.dig()
	

func create_grid(width: int, height: int) -> void:
	grid.resize(height) # Creates Y rows
	for y in range(height):
		var row = []
		row.resize(width) # Creates X columns
		for x in range(width):
			row[x] = Tile.new()
		grid[y] = row # Add X columns
