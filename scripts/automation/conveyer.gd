extends Machine

@export var direction: Vector2i = Vector2i.RIGHT
@export var capacity: int = 3          # how many items fit on one conveyor
@export var speed: float = 3.0         # speed of tiles/second
@export var center = Vector2(16,15)
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
		item.sprite.position = _item_position(item)
	if not items.is_empty() and items[0].progress >= 1.0:
		if push_item_at(items[0].id, grid_pos + direction):
			items[0].sprite.queue_free()
			items.pop_front()

func _item_position(item: Belt_Item) -> Vector2:
	if item.progress < 0.5:
		return item.entry_pos.lerp(center, item.progress / 0.5)
	return center.lerp(end_pos, (item.progress - 0.5) / 0.5)

func accept_item(id: String, from_cell: Vector2i) -> bool:
	if items.size() >= capacity: return false
	var side = from_cell - grid_pos
	if side == direction: return false #doesnt accept from destination
	if side == -direction:
		return _accept(id, start_pos)
	var back = machine_register.get_machine_at(grid_pos - direction)
	if back != null and back.is_waiting_to_push(grid_pos): return false	# back goes first
	return _accept(id, center + Vector2(side) * 16)

func _accept(id: String, entry_pos: Vector2) -> bool:
	if not items.is_empty() and items[-1].progress < spacing: return false
	var item = Belt_Item.new()
	item.id = id
	item.progress = 0.0
	item.entry_pos = entry_pos
	item.sprite = _new_sprite(id, entry_pos)
	items.append(item)
	return true

func _new_sprite(id: String, pos: Vector2) -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = ItemDB.get_item_data(id)["texture"]
	sprite.z_index = 1
	sprite.position = pos
	add_child(sprite)
	return sprite

func _is_open(side: Vector2i) -> bool:
	var neighbor = machine_register.get_machine_at(grid_pos + side)
	if neighbor == null:
		return false
	if side == direction:
		return neighbor.has_method("accept_item")
	return neighbor.outputs_to(grid_pos)

func outputs_to(cell: Vector2i) -> bool:
	return cell == grid_pos + direction

func is_waiting_to_push(cell: Vector2i) -> bool:
	return not items.is_empty() and items[0].progress >= 1.0 - spacing and cell == grid_pos + direction

class Belt_Item:
	var id: String
	var progress: float = 0.0 # 0.0 entrence 1.0 exit
	var sprite: Sprite2D
	var entry_pos: Vector2

func _is_belt(side: Vector2i) -> bool:	# is there a conveyor in that neighbouring cell?
	var neighbor = machine_register.get_machine_at(grid_pos + side)
	return neighbor != null and "direction" in neighbor
