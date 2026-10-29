class_name RecipeDB

const assembler_recipes: Dictionary[String, Dictionary] = {
	"iron_plate": {
		"crafting_time": 2.0,
		"result": {
			"iron_plate": 1
		},
		"ingredients": {
			"iron": 1
		},
	},
	"copper_plate": {
		"crafting_time": 1.5,
		"result": {
			"copper_plate": 1
		},
		"ingredients": {
			"copper": 1
		},
	},
}

static func get_assembler_recipe_data(recipe: String) -> Dictionary:
	return assembler_recipes[recipe]
