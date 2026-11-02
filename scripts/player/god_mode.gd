extends Node

@onready var player: CharacterBody2D = get_parent()
@export var collision : CollisionShape2D
@export var movement : Node
@export var camera : Camera2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("god_mode"):
		player.visible = !player.visible
		collision.disabled = !player.visible
		movement.snappy = !player.visible
		camera.position_smoothing_enabled = player.visible
