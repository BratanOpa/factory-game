extends StaticBody2D

@export var drill_size: Vector2i	# in tiles
var ore_layer: TileMapLayer
var under_tiles: Array[Vector2i]

func _ready() -> void:
	position = position.snapped(Vector2(16, 16))	# snap position to grid 16x16 px textures
	ore_layer = get_tree().get_first_node_in_group("ore_layer")
	under_tiles = _get_under_tiles()
	
func _process(delta: float) -> void:
	pass
	
func _get_under_tiles() -> Array[Vector2i]:	# get ore tiles under the drill
	var covered_tiles: Array[Vector2i] = []
	var top_left_tile = ore_layer.local_to_map(ore_layer.to_local(global_position))
	for x in range(drill_size.x):
		for y in range(drill_size.y):
			var current_tile = top_left_tile + Vector2i(x, y)
			covered_tiles.append(current_tile)
	return covered_tiles
	
func _mine() -> Dictionary:
	
	return {}
