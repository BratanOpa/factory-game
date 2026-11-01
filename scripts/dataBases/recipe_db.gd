class_name RecipeDB

const assembler_recipes: Dictionary[String, Dictionary] = {
	"gear": {
		"crafting_time": 0.5,
		"results": {
			"gear": 1
		},
		"ingredients": {
			"iron_plate": 2
		},
	},
	"copper_wire": {
		"crafting_time": 0.5,
		"results": {
			"copper_plate": 1
		},
		"ingredients": {
			"copper_wire": 1
		},
	},
}

static func get_assembler_recipe_data(recipe: String) -> Dictionary:
	return assembler_recipes[recipe]

const smelter_recipes: Dictionary[String, Dictionary] = {
	"iron_plate": {
		"crafting_time": 3.2,
		"results": {
			"iron_plate": 1
		},
		"ingredients": {
			"iron_ore": 1
		},
	},
	"copper_plate": {
		"crafting_time": 3.2,
		"results": {
			"copper_plate": 1
		},
		"ingredients": {
			"copper_ore": 1
		},
	},
	"steel": {
		"crafting_time": 16,
		"results": {
			"steel": 1,
		},
		"ingredients": {
			"iron_ore": 1,
			"coal": 1,
		},
	},
}

static func get_smelter_recipe_data(recipe: String) -> Dictionary:
	return smelter_recipes[recipe]
