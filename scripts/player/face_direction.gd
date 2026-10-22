extends Node

@onready var player: CharacterBody2D = get_parent()

@export var icon: Sprite2D
@export var speed := 10.0

func _physics_process(delta: float) -> void:
	if player.velocity.is_zero_approx():
		return
	_rotate_icon(delta)

func _rotate_icon(delta: float) -> void:
	var target_angle = player.velocity.angle()
	var current_rotation = icon.rotation
	icon.rotation = lerp_angle(current_rotation, target_angle, speed * delta)
