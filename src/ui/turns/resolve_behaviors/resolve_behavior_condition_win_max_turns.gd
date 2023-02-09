extends ConditionWinResolveBehavior
class_name ConditionWinResolveBehavior_MaxTurns

func _init():
	._init()
	
	description = "You've survived %s turns" % [String(Globals.MAX_TURNS)]
	resolve_step = Turns.STEP_ORDER.condition_win

func _execute_resolve_behavior():
	if Globals.turn_manager.is_last_turn():
		_victory()
