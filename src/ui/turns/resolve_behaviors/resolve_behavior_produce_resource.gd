extends ResourceResolveBehavior
class_name ProducerResolveBehavior

func _init():
	._init()
	resolve_step = 2
	
func _execute_resolve_behavior():
	Globals.player_resource_manager.add_to_resource(identifier, amount)
