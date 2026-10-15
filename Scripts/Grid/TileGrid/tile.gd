class_name Tile

var type: String
var pos: Vector2i
var rotation: int = 0
var ore: OreBehavior = null

func _init(type: String, position: Vector2i) -> void:
	type = type
	pos = pos

func get_type_data() -> Dictionary:
	return TileTypes.TILE_TYPES[type]
