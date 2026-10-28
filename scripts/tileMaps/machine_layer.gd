# This script register every machine, so they can easily find each other to transfer items
class_name MachineLayer
extends Node2D

signal machines_changed

const CELL_SIZE := 32

var machines: Dictionary[Vector2i, Machine] = {}

func world_to_cell(world_pos:Vector2) -> Vector2i:
	var local = to_local(world_pos)
	return Vector2i(floor(local / CELL_SIZE))

func register_machine(pos: Vector2i, size: Vector2i, machine: Machine) -> void:
	print("registering!")
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			var cell = Vector2i(x, y)
			machines[cell] = machine
	machines_changed.emit()

func unregister_machine(pos: Vector2i, size: Vector2i) -> void:
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			var cell = Vector2i(x, y)
			machines.erase(cell)
	machines_changed.emit()

func get_machine_at(pos: Vector2i) -> Machine:
	return machines.get(pos, null)
