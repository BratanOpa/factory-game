extends Machine

var item_storage : Dictionary[String, int] = {}

func accept_item(id: String) -> bool:
	var current_count = item_storage.get(id, 0)
	current_count += 1
	item_storage[id] = current_count
	print (id, current_count)
	return true
