class_name ItemDB

# A central database of all items in your game
const items: Dictionary[String, Dictionary] = {
	"iron_ore": {
		"display_name": "Iron Ore",
		"texture": preload("res://art/items/iron_ore_item.png"),
		"stack": 50,
	},
	"copper_ore": {
		"display_name": "Copper Ore",
		"texture": preload("res://art/machines/drill/mining_drill_head.png"),	# temp
		"stack": 50,
	},
	"coal": {
		"display_name": "Coal Ore",
		"texture": preload("res://art/machines/drill/mining_drill_head.png"),	# temp
		"stack": 50,
	},
	"iron_plate": {
		"display_name": "Iron plate",
		"texture": preload("res://art/items/iron_plate.png"),
		"stack": 100,
	},
	"copper_plate": {
		"display_name": "Copper plate",
		"texture": preload("res://art/machines/drill/mining_drill_head.png"),	# temp
		"stack": 100,
	},
	"gear": {
		"display_name": "Gear",
		"texture": preload("res://art/items/gear.png"),
		"stack": 100,
	},
	"stone": {
		"display_name": "Stone",
		"texture": preload("res://art/items/stone.png"),
		"stack": 100,
	},
}

static func get_item_data(item_name: String) -> Dictionary:
	return items[item_name]
