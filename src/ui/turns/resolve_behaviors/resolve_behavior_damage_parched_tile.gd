extends ResolveBehavior
class_name ParchedTileDamageResolveBehavior

export (String)var identifier : String = "water"
export var base_amount : int = 1

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.roots_damage_connected

func _execute_resolve_behavior():
	var _parched_tiles : Array = Globals.entity_manager.get_tiles_to_parche()
	var rsc : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource(identifier) as ResourceNode
	if rsc == null || rsc._is_depleted() == false:
		return
		
	for _tile in _parched_tiles:
		_tile.apply_damage(get_damage_amount(_tile))

func get_damage_amount(_tile : Tile) -> int:
	return base_amount
