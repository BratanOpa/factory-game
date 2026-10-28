class_name RecipeDB

static var assembler_recipes: Dictionary[String, Dictionary] = {
	"iron_plate": {
		"result_count": 1,
		"crafting_time": 2.0,
		"ingredients": {
			"iron": 1
		},
	},
	"copper_plate": {
		"result_count": 1,
		"crafting_time": 1.5,
		"ingredients": {
			"copper": 1
		},
	},
}

static func get_assembler_recipe_data(recipe: String) -> Dictionary:
	return assembler_recipes[recipe]
