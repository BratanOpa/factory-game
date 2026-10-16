extends TileMapLayer
# AI CODE:
const TERRAIN_SET = 0
const FLOOR = 0
const WALL_ZONE = 1

@export var walls: Walls

func _ready() -> void:
	set_cells_terrain_connect(walls.get_used_cells(),TERRAIN_SET,WALL_ZONE)
	walls.wall_destroyed.connect(_on_wall_destroyed)
	
func _on_wall_destroyed(cell: Vector2i) -> void:
	set_cells_terrain_connect([cell], TERRAIN_SET, FLOOR)
