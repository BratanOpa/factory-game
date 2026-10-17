# This script register every machine, so they can easily find each other to transfer items

extends Node2D

var machines: Dictionary = {Vector2i(): Node}

func register_machine(coords: Vector2i, machine: Node) -> void:
	machines[coords] = machine
	
func unregister_machine(coords: Vector2i) -> void:
	machines.erase(coords)
	
func get_machine_at(coords: Vector2i) -> Node:
	return machines.get(coords, null)
