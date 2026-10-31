extends Machine

@export var mining_amount : int = 1
@export var base_time: float = 1.0
@export var turns_per_item: float = 0.5	# how much the head turns while mining one item

var ore_shifter: int = 0	# just dummy indexer to mine at different cells
var stored_item: String = "" # holds the mined item if output is blocked
var ore_layer: OreLayer

func _ready() -> void:
	super()
	ore_layer = get_tree().get_first_node_in_group("ore_layer")
	_update_speed()
	$Timer.start()

func _process(delta: float) -> void:
	var working = not $Timer.is_stopped() and stored_item.is_empty()
	if working:
		$Head.rotation += TAU * turns_per_item / $Timer.wait_time * delta

func _on_timer_timeout() -> void:	# timer-node
	if stored_item.is_empty():
		var mine_result = _mine()
		if mine_result.is_empty():
			$Timer.stop()	# timer stop
			return
		stored_item = mine_result.keys()[0]
		_update_speed()
	if push_item(stored_item):
		stored_item = ""

func _update_speed() -> void:
	var tile_count = _get_valid_ore_tiles().size()
	if tile_count > 0:
		$Timer.wait_time = base_time / tile_count

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
	ore_shifter %= valid_tiles.size()
	var mined = ore_layer.mine_ore(valid_tiles[ore_shifter], mining_amount)	# 1 -> how much it mines per tick
	ore_shifter = (ore_shifter + 1) % valid_tiles.size()
	return mined

func outputs_to(cell: Vector2i) -> bool:
	return get_surrounding_cells_pos(grid_pos, machine_size).has(cell)
