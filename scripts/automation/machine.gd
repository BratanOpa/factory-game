class_name Machine
extends StaticBody2D

@export var machine_size: Vector2i = Vector2i(1, 1)
@export var tile_size: int = 32

var grid_pos: Vector2i
var machine_register: MachineRegister

func _ready() -> void:
	position = position.snapped(Vector2(tile_size, tile_size))
	machine_register = get_parent()
	grid_pos = position / Vector2(tile_size, tile_size)
	print(grid_pos)
	machine_register.register_machine(grid_pos, machine_size, self)

func _exit_tree() -> void:
	machine_register.unregister_machine(grid_pos, machine_size) # Automatically unregister when deleted

func get_surrounding_cells_pos(pos: Vector2i, size: Vector2i) -> Array[Vector2i]:	# no corners
	var cells: Array[Vector2i] = []
	for x in range(pos.x, pos.x + size.x):	# 1. Top and Bottom edges
		cells.append(Vector2i(x, pos.y - 1))          # Top row
		cells.append(Vector2i(x, pos.y + size.y))     # Bottom row
	for y in range(pos.y, pos.y + size.y):	# 2. Left and Right edges
		cells.append(Vector2i(pos.x - 1, y))          # Left column
		cells.append(Vector2i(pos.x + size.x, y))     # Right column
	return cells

func push_item(id: String) -> bool:	# may be copy to Machine class
	var target_cells = get_surrounding_cells_pos(grid_pos, machine_size)
	for pos in target_cells:
		if push_item_at(id, pos): return true
	return false
	
func push_item_at(id: String, pos: Vector2i) -> bool:
	var from_cell = pos.clamp(grid_pos, grid_pos + machine_size - Vector2i.ONE)
	var target_node = machine_register.get_machine_at(pos)
	if not target_node: return false
	if target_node.has_method("accept_item"):
		if target_node.accept_item(id, from_cell):
			return true
	return false
