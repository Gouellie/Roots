extends ResourceResolveBehavior
class_name ConditionWinResolveBehavior

var description : String = "###INSERT WIN CONDITION###"

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.condition_lose

func _victory() -> void:
	Events.emit_signal("victory", self)

func _execute_resolve_behavior():
	# to be overridden in child class
	pass
