extends Machine

var recipe_id: String
var recipe: Dictionary
var input_items: Dictionary	# iron : 10
var crafting_items: Dictionary
var output_items: Dictionary

func _ready() -> void:
	super()
	load_receipe("iron_plate") # test

func _process(delta: float) -> void:
	try_push_item()

func _on_timer_timeout() -> void:
	for item in crafting_items:
		if not output_items.has(item): output_items[item] = 0
		output_items[item] += crafting_items[item]
		crafting_items = {}
	craft()

func craft() -> bool:	# call this() when new item accepted or done craft
	var ingredients = recipe.get("ingredients", {})
	var results = recipe.get("results", {})
	if not $Timer.is_stopped() or not is_enough_ingredients() or not is_enough_space(): return false
	$Timer.start()
	for ingredient in ingredients:
		input_items[ingredient] -= ingredients.get(ingredient, 0)
	for result in results:
		if not crafting_items.has(result): crafting_items[result] = 0
		crafting_items[result] += results[result]
	return true

func load_receipe(id: String) -> bool:
	recipe_id = id
	recipe = RecipeDB.get_assembler_recipe_data(id)
	$Timer.wait_time = recipe["crafting_time"]
	return true;

func is_enough_ingredients() -> bool:
	var ingredients = recipe.get("ingredients", {})
	for ingredient in ingredients:
		if not input_items.has(ingredient) or not input_items[ingredient] >= ingredients[ingredient]: return false
	return true

func is_enough_space() -> bool:	# if output_items Dictionary has space for one more craft
	var results = recipe.get("results", {})
	for item in output_items:
		if output_items[item] + crafting_items.get(item, 0) + results.get(item, 0) > ItemDB.get_item_data(item)["stack"]: return false
	return true;

func accept_item(id: String, from_cell: Vector2i) -> bool:
	if id in recipe.get("ingredients", {}) and input_items.get(id, 0) < ItemDB.get_item_data(id)["stack"]:
		input_items[id] = input_items.get(id, 0) + 1
		craft()
		return true
	return false;

func try_push_item() -> bool:
	for item in output_items:
		if push_item(item):
			output_items[item] -= 1
			if output_items[item] <= 0:
				output_items.erase(item)
			return true
	return false
