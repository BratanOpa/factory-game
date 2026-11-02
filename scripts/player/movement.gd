extends Node

@export var speed : float = 250
@export var acceleration: float = 700
@export var friction : float = 300
@export var reverse : float = 1400

@onready var player: CharacterBody2D = get_parent()
@export var camera: Camera2D
@export var god_mode_speed : float = 400

var snappy: bool = false

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if not snappy:
		var rate = acceleration
		var dot = direction.dot(player.velocity)
		if direction.is_zero_approx():
			rate = friction
		elif dot <= 0:
			rate = reverse
		player.velocity = player.velocity.move_toward(direction * speed, rate * delta)
	else:
		player.velocity = direction * god_mode_speed / camera.zoom.x
	player.move_and_slide()
