extends ResourceResolveBehavior
class_name ConditionLoseResolveBehavior

var description : String = "###INSERT LOSE CONDITION###"

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.condition_lose

func _lose() -> void:
	Events.emit_signal("game_over", self)

func _execute_resolve_behavior():
	# to be overridden in child class
	pass
