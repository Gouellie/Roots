extends Node2D
class_name ResourceNode

# warning-ignore:unused_signal
signal node_update()

export (String)var identifier : String = "default"
export (int)var min_value : int = 0
export (int)var max_value : int = 100
export (int)var value : int = 0

var is_depleted : bool = _is_depleted()

func _ready():
	initialize()

func add_resource(amount:int) -> void:
	value = int(clamp(value + amount, min_value, max_value))
	is_depleted = _is_depleted()
	emit_signal("node_update")

func decuct_resource(amount:int) -> void:
	value = int(clamp(value - amount, min_value, max_value))
	is_depleted = _is_depleted()
	emit_signal("node_update")

func _is_depleted() -> bool:
	return value <= 0

func initialize() -> void:
	emit_signal("node_update")
