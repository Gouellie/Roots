extends ResourceResolveBehavior
class_name ProducerResolveBehavior

export (bool)var produce_when_harvesting : bool = true

func _init():
	._init()
	resolve_step = 2
	
func _execute_resolve_behavior():
	if produce_when_harvesting:
		var _h : Harvestable = get_parent() as Harvestable
		if _h == null:
			return
		if _h.is_harvesting() == false:
			return
	
	Globals.player_resource_manager.add_to_resource(identifier, amount)
