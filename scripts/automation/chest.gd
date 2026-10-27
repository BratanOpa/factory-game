extends Machine

func accept_item(id: String, _from_cell: Vector2i) -> bool:
	Storage.add(id, 1)
	#print("The ", id, " amount is now: ", Storage.get_amount(id))
	return true
