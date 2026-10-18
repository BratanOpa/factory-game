# This script register every machine, so they can easily find each other to transfer items

extends Node2D

var machines: Dictionary = {Vector2i(): Node}

func register_machine(pos: Vector2i, size: Vector2i, machine: Node) -> void:
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			var cell = Vector2i(x, y)
			machines[cell] = machine
	
func unregister_machine(pos: Vector2i, size: Vector2i) -> void:
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			var cell = Vector2i(x, y)
			machines.erase(cell)
	
func get_machine_at(pos: Vector2i) -> Node:
	return machines.get(pos, null)
