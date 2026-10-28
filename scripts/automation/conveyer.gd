extends Machine

@export var direction: Vector2i = Vector2i.RIGHT
@export var capacity: int = 3          # how many items fit on one conveyor
@export var speed: float = 3.0         # speed of tiles/second
@export var center = Vector2(16,15)
var spacing : float
var start_pos : Vector2
var end_pos : Vector2

var items: Array[Belt_Item] = []           # the queue

func _ready() -> void:
	super()
	spacing = 1.0 / capacity
	start_pos = center - Vector2(direction) * 16
	end_pos = center + Vector2(direction) * 16
	$Surface.material.set_shader_parameter("speed", speed)
	$Surface.material.set_shader_parameter("dir", direction.x)
	machine_layer.machines_changed.connect(_update_rails)
	_update_rails()

func _update_rails() -> void:
	$RailTop.visible = not _is_open(Vector2i.UP)
	$RailBottom.visible = not _is_open(Vector2i.DOWN)
	$CapLeft.visible = not _is_open(Vector2i.LEFT)
	$CapRight.visible = not _is_open(Vector2i.RIGHT)

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
	sprite.texture = ItemDatabase.get_item_data(id)["texture"]
	sprite.z_index = 1
	sprite.position = pos
	add_child(sprite)
	return sprite

func _is_open(side: Vector2i) -> bool:
	var neighbor = machine_layer.get_machine_at(grid_pos + side)
	if neighbor == null:
		return false
	if side == direction:
		return neighbor.has_method("accept_item")
	return neighbor.outputs_to(grid_pos)

func outputs_to(cell: Vector2i) -> bool:
	return cell == grid_pos + direction

class Belt_Item:
	var id: String
	var progress: float = 0.0 # 0.0 entrence 1.0 exit
	var sprite: Sprite2D
	var entry_pos: Vector2
