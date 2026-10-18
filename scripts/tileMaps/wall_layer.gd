class_name WallLayer
extends TileMapLayer

const TERRAIN_SET := 0

signal wall_destroyed(cell: Vector2i)

var walls_durability = {}

func dig(cell: Vector2i, amount: int) -> bool:
	if get_cell_source_id(cell) != -1:
		var current_durability = get_durability(cell)
		current_durability -= amount
		if current_durability <= 0:
			destroy_wall(cell)
			return true
		walls_durability[cell] = current_durability
	return false

func get_durability(cell: Vector2i) -> int:
	# check dictionary
	var durability
	durability = walls_durability.get(cell)
	if durability != null:
		return durability
	# check cell data
	var data = get_cell_tile_data(cell)
	if data:
		durability = data.get_custom_data("durability")
	if durability == null or durability <= 0:
		durability = 1
		push_warning("WALL ON ",cell," HAD NO DURABILITY SET. DEFAULTING TO 1")
	return durability

func destroy_wall(cell: Vector2i) -> void:
	set_cells_terrain_connect([cell], TERRAIN_SET, -1)
	walls_durability.erase(cell)
	wall_destroyed.emit(cell)
