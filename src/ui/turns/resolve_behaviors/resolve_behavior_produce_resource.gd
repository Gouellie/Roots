extends ResourceResolveBehavior
class_name ProducerResolveBehavior

export (bool)var produce_when_harvesting : bool = true
export (bool)var trigger_on_game_start : bool = false
var triggered_on_game_start : bool = false setget, get_triggered_on_game_start

func get_triggered_on_game_start() -> bool:
	return triggered_on_game_start

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.resources_produce
	Events.connect("init_entity_manager", self, "on_manager_init")
	Events.connect("init_player_resource_manager", self, "on_manager_init")

func on_manager_init(_manager):
	if trigger_on_game_start == false || get_triggered_on_game_start() == true:
		return		

	if Globals.player_resource_manager == null || Globals.entity_manager == null:		
		return
		
	_execute_resolve_behavior();
		

func get_amount_from_upgrades() -> int:
	var _amount = 0
	match identifier:
		Resources.WATER:
			_amount = Globals.upgrades_manager.water_level * Resources.UPGRADE_AMOUNT_PER_LEVEL_WATER
			
		Resources.SOIL:
			_amount = Globals.upgrades_manager.soil_level * Resources.UPGRADE_AMOUNT_PER_LEVEL_SOIL
			
		Resources.SUNLIGHT:
			_amount = Globals.upgrades_manager.sun_level * Resources.UPGRADE_AMOUNT_PER_LEVEL_SUNLIGHT
	
	return _amount

func get_amount() -> int:
	if _should_yield_amount():
		var _final_amount = amount + get_amount_from_upgrades()
		return _final_amount
	
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
	
	if is_instance_valid(Globals.player_resource_manager):
		Globals.player_resource_manager.get_resource_manager().add_to_resource(identifier, get_amount())
