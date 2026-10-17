class_name ItemPusher

# WARNING! AI CODE: MAYMAKENOSENSE!
 
# A static function can be called from anywhere without needing an instance
static func try_output(machine: Node2D, ore_layer: TileMapLayer, item: Dictionary) -> bool:
	const DIRECTIONS = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
	
	var current_grid_pos = ore_layer.local_to_map(ore_layer.to_local(machine.global_position))
	
	for dir in DIRECTIONS:
		var target_pos = current_grid_pos + dir
		# Look for a receiver at target_pos (replace this with your grid lookup logic)
		var receiver = _get_receiver_at(target_pos) 
		
		if receiver != null and receiver.has_method("accept_item"):
			if receiver.accept_item(item):
				return true
				
	return false

static func _get_receiver_at(pos: Vector2i) -> Node:
	# Your lookup logic here
	return null
