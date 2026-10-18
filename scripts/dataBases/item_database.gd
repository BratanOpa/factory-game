class_name ItemDatabase

# A central database of all items in your game
static var items: Dictionary[String, Dictionary] = {
	"iron": {
		"display_name": "Iron Ore",
		"texture": preload("res://tilesetsTemp/godot.svg")
	},
	"copper": {
		"display_name": "Copper Ore",
		"texture": preload("res://tilesetsTemp/godot.svg")
	},
	"coal": {
		"display_name": "Coal",
		"texture": preload("res://tilesetsTemp/godot.svg")
	}
}

static func get_item_data(item_name: String) -> Dictionary:
	return items[item_name]
