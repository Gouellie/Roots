extends ResourceResolveBehavior
class_name ConsumerResolveBehavior

func _init():
	resolve_step = 3
	
func _execute_resolve_behavior():
	player_resource_manager.deduct_from_resource(identifier, amount)
