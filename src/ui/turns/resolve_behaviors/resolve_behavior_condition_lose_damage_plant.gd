extends ConditionLoseResolveBehavior
class_name PlantDamageLoseConditionResolveBehavior

var plant : Plant
export var base_amount : int = 1

func _ready():
	description = "Your plant died"
	if get_owner() is Plant:
		plant = get_owner() as Plant
	
func _execute_resolve_behavior():
	if plant.is_master_plant:
		if Globals.entity_manager.get_connected_root_tiles().size() > 0:
			return
	else:
		if plant.connected:
			return
	
			
	plant.apply_damage(get_damage_amount())
	
func get_damage_amount() -> int:
	return base_amount
