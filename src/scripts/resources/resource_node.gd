extends Node2D
class_name ResourceNode

export var identifier = "default"
export var min_value :int= 0
export var max_value :int= 1000
var value :int= 0

func add_resource(amount:int) -> void:
	value = int(clamp(value + amount, min_value, max_value))

func remove_resource(amount:int) -> void:
	value = int(clamp(value - amount, min_value, max_value))