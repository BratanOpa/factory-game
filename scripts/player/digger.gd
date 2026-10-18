extends Node2D

var walls: WallLayer
@export var dig_damage := 10
@export var allowed_distance := 3

func _ready() -> void:
	walls = get_tree().get_first_node_in_group("walls_layer")

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var m_event: InputEventMouseButton = event
	if m_event.pressed and m_event.button_index == MOUSE_BUTTON_LEFT:
		var cell : Vector2i = walls.local_to_map(walls.get_local_mouse_position())
		var pixel_pos = walls.map_to_local(cell)
		var global_pixel_pos: Vector2 = walls.to_global(pixel_pos)
		if global_position.distance_to(global_pixel_pos) < allowed_distance * 32:
			walls.dig(cell, dig_damage)
