extends Node

@export var speed := 150

@onready var player: CharacterBody2D = get_parent()

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	player.velocity = direction * speed
	player.move_and_slide()
