extends VBoxContainer

var rows : Dictionary[String, HBoxContainer] = {}

const ROW = preload("res://scenes/UI/storage_row.tscn")

func _ready() -> void:
	Storage.changed.connect(_on_storage_changed)

func _on_storage_changed(id: String, new_amount: int) -> void:
	var item_row = _get_row(id)
	var label: Label = item_row.get_node("Amount")
	var item_amount = str(new_amount)
	label.text = item_amount

func _get_row(id: String) -> HBoxContainer:
	if rows.has(id):
		return rows[id]
	return _add_row(id)

func _add_row(id: String) -> HBoxContainer:
	var row  = ROW.instantiate()
	var icon : TextureRect = row.get_node("Icon")
	var item_name : String = ItemDatabase.get_item_data(id)["display_name"]
	row.tooltip_text = item_name
	icon.texture = ItemDatabase.get_item_data(id)["texture"]
	rows[id] = row
	add_child(row)
	return row
