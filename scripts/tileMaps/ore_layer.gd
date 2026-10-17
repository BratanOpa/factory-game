class_name OreLayer
extends TileMapLayer

var ore_amounts_dict: Dictionary = {}	# Contains amount ore remaining

func set_ore_amounts(coords: Vector2i, amount: int) -> bool:
	if !_sync_cell(coords): return false
	ore_amounts_dict[coords] = amount
	_remove_if_empty(coords)	# remove cell if empty
	return true

func get_ore_amounts(coords: Vector2i) -> int:
	if !_sync_cell(coords): return -1
	return ore_amounts_dict[coords]

func get_ore_type(coords: Vector2i) -> String:	# "" means error
	if !_sync_cell(coords): return ""
	return get_cell_tile_data(coords).get_custom_data("OreType")

func mine_ore(coords: Vector2i, amount: int) -> Dictionary:	# Returns what and how much digged { iron : 3 }
	if amount < 0: return {}; # No negative values
	var ore_amounts = get_ore_amounts(coords)
	var ore_type = get_ore_type(coords)
	if ore_amounts < amount:	# Not enough ore
		set_ore_amounts(coords, 0);
		return {ore_type : ore_amounts}
	set_ore_amounts(coords, ore_amounts_dict[coords] - amount);
	return {ore_type : amount}

func _sync_cell(coords: Vector2i) -> bool:	# Verifies that cell is in Dictionary or return false
	if not ore_amounts_dict.has(coords):	# No cell in dictionary
		if get_cell_source_id(coords) == -1:	# No cell in TileMapLayer
			return false # Error, no cell at coords
		ore_amounts_dict[coords] = get_cell_tile_data(coords).get_custom_data("DefaultAmount")
	return true
	
func _remove_if_empty(coords: Vector2i) -> bool:	# true if cell deleted
	if get_ore_amounts(coords) <= 0:
		ore_amounts_dict.erase(coords)
		erase_cell(coords)
		return true
	return false
