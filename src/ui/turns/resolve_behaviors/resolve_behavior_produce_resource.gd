extends ResourceResolveBehavior
class_name ProducerResolveBehavior

export (bool)var produce_when_harvesting : bool = true

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.resources_produce

func get_amount() -> int:
	if _should_yield_amount():
		return amount
	
	return 0

func _should_yield_amount() -> bool:
	if produce_when_harvesting:
		var _h : Harvestable = get_parent() as Harvestable
		if _h == null:
			return false
		if _h.is_harvesting() == false:
			return false
			
	return true

func _execute_resolve_behavior():
	if _should_yield_amount() == false:
		return
	
	Globals.player_resource_manager.get_resource_manager().add_to_resource(identifier, amount)
