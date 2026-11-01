extends BaseCrafter

func load_receipe(id: String) -> bool:
	recipe_id = id
	recipe = RecipeDB.get_smelter_recipe_data(id)
	$Timer.wait_time = recipe["crafting_time"]
	return true;

func _ready() -> void:
	super()
	load_receipe("iron_plate") # test
