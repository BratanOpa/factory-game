extends Node

signal changed(id: String, amount: int)

var items: Dictionary[String, int] = {}

func add(id: String, amount: int) -> void:
	items[id] = items.get(id, 0) + amount
	changed.emit(id, items[id])

func get_amount(id: String) -> int:
	return items.get(id, 0)
