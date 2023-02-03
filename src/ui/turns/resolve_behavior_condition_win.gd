extends ResourceResolveBehavior
class_name ConditionWinResolveBehavior

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.condition_win

func _victory() -> void:
	Events.emit_signal("victory")

func _execute_resolve_behavior():
	# to be overridden in child class
	pass
