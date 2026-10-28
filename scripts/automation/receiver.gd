extends Machine

func accept_item(id: String, _from_cell: Vector2i) -> bool:
	Storage.add(id, 1)
	$Glow.visible = true
	$GlowTimer.start()
	return true

func _on_glow_timer_timeout() -> void:
	$Glow.visible = false
