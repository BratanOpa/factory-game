extends Machine

var current_tile_index: int = 0	# just dummy indexer
var stored_item: String = "" # holds the mined item if output is blocked

@export var mining_amount : int = 1

func _on_timer_timeout() -> void:	# timer-node
	if not stored_item.is_empty():
		if push_item(stored_item):
			stored_item = ""
		else:
			return
	var mine_result = _mine()
	if mine_result.is_empty():
		$Timer.stop()	# timer stop
		return
	stored_item = mine_result.keys()[0]
	print(stored_item)

func _get_under_pos() -> Array[Vector2i]:	# get ore tiles pos under the drill
	var covered_tiles: Array[Vector2i] = []
	for x in range(machine_size.x):
		for y in range(machine_size.y):
			var current_tile = grid_pos + Vector2i(x, y)
			covered_tiles.append(current_tile)
	return covered_tiles

func _get_valid_ore_tiles() -> Array[Vector2i]:
	var valid_tiles: Array[Vector2i] = []
	for pos in _get_under_pos():
		if ore_layer.get_cell_source_id(pos) != -1:
			valid_tiles.append(pos)
	return valid_tiles

func _mine() -> Dictionary:
	var valid_tiles = _get_valid_ore_tiles()
	if valid_tiles.size() == 0: return {}
	current_tile_index %= valid_tiles.size()
	var mined = ore_layer.mine_ore(valid_tiles[current_tile_index], mining_amount)	# 1 -> how much it mines per tick
	current_tile_index = (current_tile_index + 1) % valid_tiles.size()
	return mined
