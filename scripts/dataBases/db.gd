extends Node

const ITEMS := {
	"iron_ore":   {"name": "Iron Ore",   "stack": 50},
	"iron_plate": {"name": "Iron Plate", "stack": 100},
	"gear":       {"name": "Gear",       "stack": 100},
}

const RECIPES := {
	"iron_plate": {"inputs": {"iron_ore": 1},   "outputs": {"iron_plate": 1}, "time": 2.0},
	"gear":       {"inputs": {"iron_plate": 2}, "outputs": {"gear": 1},       "time": 1.0},
}

const MACHINES := {
	"furnace":   {"name": "Furnace",   "size": Vector2i(2, 2), "recipes": ["iron_plate"]},
	"assembler": {"name": "Assembler", "size": Vector2i(3, 3), "recipes": ["gear"]},
}
