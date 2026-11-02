extends BaseCrafter

func load_receipe(id: String) -> bool:
	recipe = RecipeDB.get_smelter_recipe_data(id)
	return true;
