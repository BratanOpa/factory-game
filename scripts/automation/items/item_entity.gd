extends Area2D

var id: String
var display_name: String

func setup(id: String) -> void:	# no init, first instanciate scene, then call this func
	self.id = id
	var data: Dictionary = ItemDatabase.get_item_data(id)
	display_name = data["display_name"]
	$Sprite2D.texture = data["texture"]

func get_display_name() -> String:
	return display_name
