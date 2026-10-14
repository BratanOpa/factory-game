class_name OreBehavior

var amount: int

func _init(start_amount: int) -> void:
	amount = start_amount

func dig() -> void:
	amount -= 1
	print("копнул, осталось: ", amount)
