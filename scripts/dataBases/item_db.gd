class_name ItemDB

# A central database of all items in your game
const items: Dictionary[String, Dictionary] = {
	"iron": {
		"display_name": "Iron Ore",
		"texture": preload("res://art/items/iron_ore_item.png"),
		"stack": 50,
	},
	"copper": {
		"display_name": "Copper Ore",
		"texture": preload("res://tilesetsTemp/godot.svg"),	# temp
		"stack": 50,
	},
	"coal": {
		"display_name": "Coal Ore",
		"texture": preload("res://tilesetsTemp/godot.svg"),	# temp
		"stack": 50,
	},
	"iron_plate": {
		"display_name": "Iron plate",
		"texture": preload("res://art/machines/drill/mining_drill_head.png"),	# temp
		"stack": 100,
	},
	"copper_plate": {
		"display_name": "Copper plate",
		"texture": preload("res://tilesetsTemp/godot.svg"),	# temp
		"stack": 100,
	},
}

static func get_item_data(item_name: String) -> Dictionary:
	return items[item_name]
