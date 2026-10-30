extends Machine

func accept_item(item: ItemEntity, _from_cell: Vector2i) -> bool:
	Storage.add(item.id, 1)
	item.queue_free()
	$Glow.visible = true
	$GlowTimer.start()
	return true

func _on_glow_timer_timeout() -> void:
	$Glow.visible = false
