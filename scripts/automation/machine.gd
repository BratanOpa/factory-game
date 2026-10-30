class_name Machine
extends StaticBody2D

@export var machine_size: Vector2i = Vector2i(1, 1) # e.g., 2x2
@export var accepted_items: Array[String]

const TILE_SIZE: int = 32
const ITEM_SCENE = preload("res://scenes/item_entity.tscn")

var machine_register: MachineRegister
var grid_pos: Vector2i
var push_shifter: int = -1	# dummy index shifter, so it push att diff positions

func _ready() -> void:
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	machine_register = get_parent()
	grid_pos = machine_register.world_to_cell(global_position)
	machine_register.register_machine(grid_pos, machine_size, self)

func _exit_tree() -> void:
	pass	# machine_register removes before this func call, which creates error
	#machine_register.unregister_machine(grid_pos, machine_size) # Automatically unregister when deleted

func get_surrounding_cells_pos(pos: Vector2i, size: Vector2i) -> Array[Vector2i]:	# no corners
	var cells: Array[Vector2i] = []
	for x in range(pos.x, pos.x + size.x):	# 1. Top and Bottom edges
		cells.append(Vector2i(x, pos.y - 1))          # Top row
		cells.append(Vector2i(x, pos.y + size.y))     # Bottom row
	for y in range(pos.y, pos.y + size.y):	# 2. Left and Right edges
		cells.append(Vector2i(pos.x - 1, y))          # Left column
		cells.append(Vector2i(pos.x + size.x, y))     # Right column
	return cells

func push_item(item: ItemEntity) -> bool:
	var target_cells = get_surrounding_cells_pos(grid_pos, machine_size)
	for i in target_cells:
		push_shifter = (push_shifter + 1) % target_cells.size()
		if push_item_at(item, target_cells[push_shifter]): return true
	return false
	
func push_item_at(item: ItemEntity, pos: Vector2i) -> bool:
	var from_cell = pos.clamp(grid_pos, grid_pos + machine_size - Vector2i.ONE)
	var target_node = machine_register.get_machine_at(pos)
	if target_node and target_node.has_method("accept_item") and target_node.accept_item(item, from_cell): return true
	return false

func outputs_to(_cell: Vector2i) -> bool:
	return false

func spawn_item(id: String) -> ItemEntity:	# create a new item (hidden) in the shared ItemLayer
	var item_layer = get_tree().get_first_node_in_group("item_layer")
	var item: ItemEntity = ITEM_SCENE.instantiate()
	item_layer.add_child(item)
	item_layer.move_child(item, 0)	# newest item = first in the list = drawn under all others
	item.setup(id)
	item.visible = false			# still inside the machine
	return item
