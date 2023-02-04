extends ResolveBehavior
class_name ParchedPlantDamageResolveBehavior

export (String)var identifier : String = "soil"
export var base_amount : int = 1

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.plant_damage

func _execute_resolve_behavior():
	var _parched_plants : Array = Globals.entity_manager.get_plants_to_parche()
	var rsc : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource(identifier) as ResourceNode
	if rsc == null || rsc._is_depleted() == false:
		return
		
	for _plant in _parched_plants:
		_plant.apply_damage(get_damage_amount(_plant))

func get_damage_amount(plant : Plant) -> int:
	return base_amount
