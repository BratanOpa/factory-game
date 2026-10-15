class_name OreBehavior

var config: Dictionary
var amount: int

func _init(cfg: Dictionary) -> void:
	config = cfg
	amount = randi_range(cfg.min, cfg.max)

func dig() -> void:
	amount -= 1
	print("копнул, осталось: ", amount)
