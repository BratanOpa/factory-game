extends TileMapLayer

var oreAmount: Dictionary = {}	#Contains amount ore remaining

func _ready() -> void:
	pass

func setOreAmount(coords: Vector2i, amount: int) -> void:
	if $TileMapLayer.get_cell_source_id(coords) != -1:
	if not oreAmount.has(coords):
		oreAmount[coords] = {}
	oreAmount[coords]["ore_amount"] = amount

# Функция получения количества руды
func get_cell_ore_amount(coords: Vector2i) -> int:
	if oreAmount.has(coords) and oreAmount[coords].has("ore_amount"):
		return oreAmount[coords]["ore_amount"]
	return 0 # Дефолтное значение, если данных нет
