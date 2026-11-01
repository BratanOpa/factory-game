extends BaseCrafter

func load_receipe(id: String) -> bool:
	recipe_id = id
	recipe = RecipeDB.get_assembler_recipe_data(id)
	$Timer.wait_time = recipe["crafting_time"]
	return true;

func _ready() -> void:
	super()
	load_receipe("gear") # test
