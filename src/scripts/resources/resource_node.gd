extends Node2D
class_name ResourceNode

# warning-ignore:unused_signal
signal node_update()

# warning-ignore:unused_signal
signal node_depleted()

export (String)var identifier : String = "default"
export (int)var min_value : int = 0
export (int)var max_value : int = 1000000
export (int)var value : int = 0
export (bool)var reset_on_next_turn = false
export (bool)var has_limits = true

var delta : int = 0
var start : int = 0

func get_value() -> int:
	return int(clamp(value, min_value, max_value))

var is_depleted : bool = _is_depleted()

func _ready():
	initialize()
	start = value
	Turns.connect("turn_next", self, "on_next_turn")

func on_next_turn(_turn):
	if reset_on_next_turn:
		value = min_value
		
	start = value
	delta = 0
	
func add_resource(amount:int) -> void:
	delta += amount
	value += amount
	if has_limits:
		value = int(clamp(value, min_value, max_value))
	
	is_depleted = _is_depleted()
	emit_signal("node_update")

func decuct_resource(amount:int) -> void:
	delta -= amount
	value -= amount
	if has_limits:
		value = int(clamp(value, min_value, max_value))
		
	is_depleted = _is_depleted()
	emit_signal("node_update")
	if is_depleted:
		emit_signal("node_depleted")

func _is_depleted() -> bool:
	return value <= min_value

func initialize() -> void:
	emit_signal("node_update")
