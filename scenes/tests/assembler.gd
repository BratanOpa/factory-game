extends Machine

var recipe_id: String
var recipe: Dictionary

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func accept_item(id: String, from_cell: Vector2i) -> bool:
	if id in recipe["ingredients"]:
		pass
	return false;

func load_receipe(id: String) -> bool:
	recipe_id = id
	recipe = RecipeDB.get_assembler_recipe_data(id)
	return true;
