class_name Machine
extends StaticBody2D

@export var machine_size: Vector2i = Vector2i(1, 1) # e.g., 2x2
var grid_pos: Vector2i
var ore_layer: OreLayer

func _ready() -> void:
	position = position.snapped(Vector2(32,32))
	ore_layer = get_tree().get_first_node_in_group("ore_layer")
	grid_pos = ore_layer.local_to_map(ore_layer.to_local(global_position))
	get_parent().register_machine(grid_pos, machine_size, self)

func _exit_tree() -> void:
	get_parent().unregister_machine(grid_pos, machine_size) # Automatically unregister when deleted

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
	var machines : MachineLayer = get_parent()
	for cell_pos in target_cells:
		var target_node = machines.get_machine_at(cell_pos)
		if not target_node: continue
		if target_node.has_method("accept_item"):
			if target_node.accept_item(id):
				return true
	return false
