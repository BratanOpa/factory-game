extends Machine

@export var direction: Vector2i = Vector2i.RIGHT
@export var capacity: int = 3          # how many items fit on one conveyor
@export var speed: float = 3.0         # speed of tiles/second
@export var center = Vector2(16,12)
var spacing : float
var start_pos : Vector2
var end_pos : Vector2

var items: Array[Belt_Item] = []           # the queue

func _ready() -> void:
	super()
	spacing = 1.0 / capacity
	start_pos = center - Vector2(direction) * 16
	end_pos = center + Vector2(direction) * 16
	$Sprite2D.rotation = Vector2(direction).angle()

func _process(delta: float) -> void:
	for i in items.size():
		var item = items[i] # current item
		var limit: float # how far it's allowed to go
		
		if i == 0:
			limit = 1.0
		else:
			limit = items[i-1].progress - spacing
		item.progress = move_toward(item.progress, limit, speed * delta)
		item.sprite.position = start_pos.lerp(end_pos, item.progress)
	if not items.is_empty() and items[0].progress >= 1.0:
		if push_item_at(items[0].id, grid_pos + direction):
			items[0].sprite.queue_free()
			items.pop_front()

func accept_item(id: String, from_cell: Vector2i) -> bool:
	if from_cell - grid_pos == direction: return false #doesnt accept from destination
	if items.size() >= capacity: return false
	if not items.is_empty() and items[-1].progress < spacing: return false
	# accepted
	var item = Belt_Item.new()
	item.id = id
	item.progress = 0.0
	item.sprite = _new_sprite(id, start_pos)
	items.append(item)
	return true

func _new_sprite(id: String, pos: Vector2) -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = ItemDatabase.get_item_data(id)["texture"]
	sprite.z_index = 1
	sprite.position = pos
	add_child(sprite)
	return sprite

class Belt_Item:
	var id: String
	var progress: float = 0.0 # 0.0 entrence 1.0 exit
	var sprite: Sprite2D
