extends Camera2D

@export var comfort_zooms : Array[float]= [0.25 ,0.5, 1, 2, 3, 5, 10, 20]
@export var current_zoom := 3
@export var speed : float = 6.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		current_zoom = clampi(current_zoom + 1, 0, comfort_zooms.size() - 1)
	elif event.is_action_pressed("zoom_out"):
		current_zoom = clampi(current_zoom - 1, 0, comfort_zooms.size() - 1)

func _process(delta: float) -> void:
	var current = comfort_zooms.get(current_zoom)
	zoom = lerp(zoom, Vector2.ONE * current, speed * delta)
