extends Machine

var direction: Vector2i


func _ready() -> void:
	_snap_angle()


func _process(delta: float) -> void:
	pass


func _snap_angle():
	round(rotation_degrees / 90.0) * 90.0
	match int(posmod(rotation_degrees, 360.0)):
		0:   return Vector2i(1, 0)   # Right
		90:  return Vector2i(0, 1)   # Down
		180: return Vector2i(-1, 0)  # Left
		270: return Vector2i(0, -1)  # Up
