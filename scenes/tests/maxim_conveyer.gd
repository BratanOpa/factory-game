extends Machine

@export var capacity: int = 3          # how many items fit on one conveyor
@export var speed: float = 1.0         # speed of tiles/second
var spacing : float

var items: Array[Belt_Item] = []           # the queue
var direction: Vector2i

func _ready() -> void:
	super()
	spacing = 1.0 / capacity
	direction = _get_direction_from_rotation()

func _process(delta: float) -> void:
	for i in items.size():
		var item = items[i] # current item
		var limit: float # how far it's allowed to go
		
		if i == 0:
			limit = 1.0
		else:
			limit = items[i-1].progress - spacing
		item.progress = move_toward(item.progress, limit, speed * delta)
	if not items.is_empty() and items[0].progress >= 1.0:
		if push_item_at(items[0].id, grid_pos + direction):
			items.pop_front()

func accept_item(id: String) -> bool:
	if items.size() >= capacity: return false
	if not items.is_empty() and items[-1].progress < spacing: return false
	var item = Belt_Item.new()
	item.id = id
	item.progress = 0.0
	items.append(item)
	return true

func _get_direction_from_rotation() -> Vector2i:
	var round_rotation = round(rotation_degrees / 90.0) * 90.0
	match posmod(int(round_rotation), 360):
		0:   return Vector2i(1, 0)   # Right
		90:  return Vector2i(0, 1)   # Down
		180: return Vector2i(-1, 0)  # Left
		270: return Vector2i(0, -1)  # Up
	return Vector2i.RIGHT

class Belt_Item:
	var id: String
	var progress: float = 0.0 # 0.0 entrence 1.0 exit
	
