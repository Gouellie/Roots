extends Node2D
class_name ResolveBehavior

var resolve_step : int = 1

func _ready():
	Turns.resolve_behaviors.append(self)

func _execute_resolve_behavior():
	# intended to be overridden
	pass
