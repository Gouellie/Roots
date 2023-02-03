extends ConditionWinResolveBehavior
class_name ConditionWinResolveBehavior_MaxTurns

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.condition_win
	
func _execute_resolve_behavior():
	if Globals.turn_manager.is_last_turn() == false:
		return
	
	_victory()
