extends Node2D

@export var target_node: Node

func _ready():
	# Test to dig ore
	target_node.set_ore_amounts(Vector2i(0, 0), 11)
	print(target_node.get_ore_amounts(Vector2i(0, 0)));
	for i in range(7):
		print(target_node.mine_ore(Vector2i(0, 0), 2));	# -1 means no such cell 
	
