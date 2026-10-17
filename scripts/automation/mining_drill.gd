extends StaticBody2D

@export var drill_size: Vector2i	# in tiles 2x2y
var ore_layer: TileMapLayer

var grid_pos: Vector2i	# coordinate to top left cell of machine
var current_tile_index: int = 0

func _ready() -> void:
	position = position.snapped(Vector2(16, 16))	# snap position to grid 16x16 px textures
	ore_layer = get_tree().get_first_node_in_group("ore_layer")
	grid_pos = ore_layer.local_to_map(ore_layer.to_local(global_position))
	get_parent().register_machine(grid_pos, self)	# register self into grid
	
func _on_timer_timeout() -> void:	# timer-node
	var mined = _mine()
	if mined.is_empty(): # no ore
		$Timer.stop()	# timer stop
		return
	print(mined)
	
func _get_under_pos() -> Array[Vector2i]:	# get ore tiles pos under the drill
	var covered_tiles: Array[Vector2i] = []
	for x in range(drill_size.x):
		for y in range(drill_size.y):
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
	var mined = ore_layer.mine_ore(valid_tiles[current_tile_index], 25)
	current_tile_index = (current_tile_index + 1) % valid_tiles.size()
	return mined
