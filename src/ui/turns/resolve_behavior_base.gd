extends Node2D
class_name ResolveBehavior

var resolve_step : int = 1

var is_enabled : bool = true setget set_is_enabled, get_is_enabled

func set_is_enabled(_b : bool):
	is_enabled = _b

func get_is_enabled() -> bool:
	return is_enabled

func _ready():
	Turns.resolve_behaviors.append(self)

func _execute_resolve_behavior():
	# intended to be overridden
	pass
