extends CharacterBody2D

var walls: WallLayer
@export var dig_damage := 10

func _ready() -> void:
	walls = get_tree().get_first_node_in_group("walls_layer")

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 150
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var m_event: InputEventMouseButton = event
	if m_event.pressed and m_event.button_index == MOUSE_BUTTON_LEFT:
		var cell = walls.local_to_map(walls.get_local_mouse_position())
		walls.dig(cell, dig_damage)
