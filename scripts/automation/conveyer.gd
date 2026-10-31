extends Machine

const ITEM_SCENE = preload("res://scenes/item_entity.tscn")

@export var direction: Vector2i = Vector2i.RIGHT
@export var capacity: int = 3          # how many items fit on one conveyor
@export var speed: float = 3.0         # speed of tiles/second
@export var center = Vector2(16,15)
@export var merge_speed: float = 2.0
var spacing : float
var start_pos : Vector2
var end_pos : Vector2
var belt: Node2D
const CORNER_FRAMES = {	# whole corner frame, by (side_in + direction) = the inner corner
	Vector2i(-1, -1): preload("res://art/machines/conveyor/corner_tl.png"),
	Vector2i(1, -1): preload("res://art/machines/conveyor/corner_tr.png"),
	Vector2i(1, 1): preload("res://art/machines/conveyor/corner_br.png"),
	Vector2i(-1, 1): preload("res://art/machines/conveyor/corner_bl.png"),
}

var items: Array[Belt_Item] = []           # the queue

func _ready() -> void:
	super()
	spacing = 1.0 / capacity
	start_pos = center - Vector2(direction) * 16
	end_pos = center + Vector2(direction) * 16
	machine_register.machines_changed.connect(_update_rails)
	_update_rails()

func _update_rails() -> void:
	var left = Vector2i(direction.y, -direction.x)
	var side_in = Vector2i.ZERO
	if not _is_open(-direction):
		if _is_open(left) and not _is_open(-left): side_in = left
		elif _is_open(-left) and not _is_open(left): side_in = -left
	var turning = side_in != Vector2i.ZERO

	$Corner.visible = turning
	$Horizontal.visible = not turning and direction.x != 0
	$Vertical.visible = not turning and direction.x == 0

	if turning:
		$Corner/Frame.texture = CORNER_FRAMES[side_in + direction]
		var mat = $Corner/Surface.material
		mat.set_shader_parameter("side_in", Vector2(side_in))
		mat.set_shader_parameter("dir_out", Vector2(direction))
		mat.set_shader_parameter("speed", speed)
		return

	belt = $Horizontal if direction.x != 0 else $Vertical
	var surface = belt.get_node("Surface")
	surface.material.set_shader_parameter("speed", speed)
	surface.material.set_shader_parameter("dir", Vector2(direction))
	surface.material.set_shader_parameter("offset", surface.position)
	belt.get_node("Up").visible = not _is_open(Vector2i.UP)
	belt.get_node("Down").visible = not _is_open(Vector2i.DOWN)
	belt.get_node("Left").visible = not _is_open(Vector2i.LEFT)
	belt.get_node("Right").visible = not _is_open(Vector2i.RIGHT)
	# side openings: belt patch that scrolls inward + rail stubs that bend into the feeder's rails
	if direction.x != 0:
		_set_inlet("Up", Vector2i.UP)
		_set_inlet("Down", Vector2i.DOWN)
	else:
		_set_inlet("Left", Vector2i.LEFT)
		_set_inlet("Right", Vector2i.RIGHT)

func _set_inlet(side_name: String, side: Vector2i) -> void:
	var open = _is_open(side)
	var patch: Sprite2D = belt.get_node("In" + side_name)
	patch.visible = open
	belt.get_node("Open" + side_name).visible = open
	# horizontal belts: the stub's rail runs on to the edge only where another belt continues it
	if direction.x != 0:
		belt.get_node("Open" + side_name + "L").visible = open and _is_belt(Vector2i.LEFT)
		belt.get_node("Open" + side_name + "R").visible = open and _is_belt(Vector2i.RIGHT)
	patch.material.set_shader_parameter("speed", speed)
	patch.material.set_shader_parameter("dir", Vector2(-side))	# moves inward, toward the belt
	patch.material.set_shader_parameter("offset", patch.position)

func _process(delta: float) -> void:
	for i in items.size():
		var item = items[i] # current item
		var limit: float # how far it's allowed to go
		if i == 0:
			limit = 1.0
		else:
			limit = items[i-1].progress - spacing
		item.progress = move_toward(item.progress, limit, speed * delta)
		item.lateral = item.lateral.move_toward(Vector2.ZERO, speed * 32.0 * merge_speed * delta)
		item.entity.global_position = to_global(_item_position(item))
	if not items.is_empty() and items[0].progress >= 1.0:
		if _push_entity(items[0].entity, grid_pos + direction):
			items.pop_front()

func _item_position(item: Belt_Item) -> Vector2:
	if item.progress < 0.5:
		return item.entry_pos.lerp(center, item.progress / 0.5) + item.lateral
	return center.lerp(end_pos, (item.progress - 0.5) / 0.5) + item.lateral

func _push_entity(entity: ItemEntity, cell: Vector2i) -> bool:	# hand the item to whatever is in front
	var target = machine_register.get_machine_at(cell)
	if target == null: return false
	if target.has_method("accept_entity"):		# another belt: pass the same node on
		return target.accept_entity(entity, grid_pos)
	if push_item_at(entity.id, cell):			# a machine: it only needs the id
		entity.queue_free()
		return true
	return false

func accept_item(id: String, from_cell: Vector2i) -> bool:	# from machines: just an id
	return _receive(id, null, from_cell)

func accept_entity(entity: ItemEntity, from_cell: Vector2i) -> bool:	# from other belts: the item node itself
	return _receive(entity.id, entity, from_cell)

func _receive(id: String, entity: ItemEntity, from_cell: Vector2i) -> bool:
	if items.size() >= capacity: return false
	var side = from_cell - grid_pos
	if side == direction: return false # doesn't accept from its destination
	if side == -direction:
		return _accept(id, entity, start_pos)
	if _is_open(-direction):
		return _merge(id, entity, side) # T-junction: merge into the middle
	return _accept(id, entity, center + Vector2(side) * 16) # corner: L-path from the side edge

func _merge(id: String, entity: ItemEntity, side: Vector2i) -> bool:
	var index = items.size() # where in the queue the new item goes
	for i in items.size():
		if items[i].progress < 0.5:
			index = i
			break
	if index > 0 and items[index - 1].progress < 0.5 + spacing: return false # item ahead too close
	if index < items.size() and items[index].progress > 0.5 - spacing: return false # item behind too close
	if entity == null:
		entity = _spawn_entity(id)	# came from a machine: the item gets its node now
	var item = Belt_Item.new()
	item.entity = entity
	item.progress = 0.5
	item.entry_pos = start_pos
	item.lateral = Vector2(side) * 16 # starts at the side edge
	_place(entity, center + item.lateral)
	items.insert(index, item)
	return true

func _accept(id: String, entity: ItemEntity, entry_pos: Vector2) -> bool:
	if not items.is_empty() and items[-1].progress < spacing: return false
	if entity == null:
		entity = _spawn_entity(id)	# came from a machine: the item gets its node now
	var item = Belt_Item.new()
	item.entity = entity
	item.progress = 0.0
	item.entry_pos = entry_pos
	_place(entity, entry_pos)
	items.append(item)
	return true

func _place(entity: ItemEntity, local_pos: Vector2) -> void: # put the item on this belt at a point
	entity.visible = true
	entity.global_position = to_global(local_pos)

func _spawn_entity(id: String) -> ItemEntity:	# make the node for an item that enters the belts
	var entity: ItemEntity = ITEM_SCENE.instantiate()
	machine_register.item_layer.add_child(entity)
	machine_register.item_layer.move_child(entity, 0)	# newest = drawn under the others
	entity.setup(id)
	return entity

func _is_open(side: Vector2i) -> bool:
	var neighbor = machine_register.get_machine_at(grid_pos + side)
	if neighbor == null:
		return false
	if side == direction:
		return neighbor.has_method("accept_item")
	return neighbor.outputs_to(grid_pos)

func outputs_to(cell: Vector2i) -> bool:
	return cell == grid_pos + direction

class Belt_Item:
	var entity: ItemEntity
	var progress: float = 0.0 # 0.0 entrence 1.0 exit
	var entry_pos: Vector2
	var lateral: Vector2 = Vector2.ZERO	# sideways offset in px, shrinks to 0 after a side merge

func _is_belt(side: Vector2i) -> bool:	# is there a conveyor in that neighbouring cell?
	var neighbor = machine_register.get_machine_at(grid_pos + side)
	return neighbor != null and "direction" in neighbor
