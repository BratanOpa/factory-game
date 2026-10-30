class_name ItemEntity
extends Node2D

var id: String

func setup(new_id: String) -> void:
	id = new_id
	$Sprite2D.texture = ItemDB.get_item_data(id)["texture"]
