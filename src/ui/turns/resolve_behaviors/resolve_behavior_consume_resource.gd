extends ResourceResolveBehavior
class_name ConsumerResolveBehavior

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.resources_consume
	
func _execute_resolve_behavior():
	Globals.player_resource_manager.get_resource_manager().deduct_from_resource(identifier, amount)
