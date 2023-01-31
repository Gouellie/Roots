extends Node2D
class_name ResourceNode

export (String)var identifier : String = "default"
export (int)var min_value : int = 0
export (int)var max_value : int = 100
export (int)var default_value : int = 50

var value : int = 0
var is_depleted : bool = _is_depleted()

func _ready():
	initialize()

func add_resource(amount:int) -> void:
	value = int(clamp(value + amount, min_value, max_value))
	is_depleted = _is_depleted()
	Events.emit_signal("resource_update_amount", identifier, value)

func deduct_resource(amount:int) -> void:
	value = int(clamp(value - amount, min_value, max_value))
	is_depleted = _is_depleted()
	Events.emit_signal("resource_update_amount", identifier, value)

func _is_depleted() -> bool:
	return value <= 0

func initialize() -> void:
	value = default_value
	Events.emit_signal("resource_node_updated", identifier, self)
