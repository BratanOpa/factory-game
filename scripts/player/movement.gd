extends Node

@export var speed : float = 200
@export var acceleration: float = 700
@export var friction : float = 300

@onready var player: CharacterBody2D = get_parent()

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var rate = acceleration
	if direction.is_zero_approx():
		rate = friction
	player.velocity = player.velocity.move_toward(direction * speed, rate * delta)
	player.move_and_slide()
