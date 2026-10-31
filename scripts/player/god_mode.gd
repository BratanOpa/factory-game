extends Node

@onready var player: CharacterBody2D = get_parent()
@export var collision : CollisionShape2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("god_mode"):
		player.visible = !player.visible
		collision.disabled = !player.visible
