extends ResolveBehavior
class_name NoResourcesDamageResolveBehavior

export (String)var identifier : String = "water"
export var base_amount : int = 1

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.roots_damage_connected

func _execute_resolve_behavior():
	var rsc : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource(identifier) as ResourceNode
	if rsc == null || rsc._is_depleted() == false:
		return

	var _sorted_tiles : Array = Globals.entity_manager.get_tiles_sorted_by_distance()
	var _net_resources : int = rsc.value
	if _net_resources >= 0:
		return
		
	var _i = 0
	
	for _t in _sorted_tiles:
		if _t is Tile:
			var _tile : Tile = _t as Tile
			
			var _did_consume : bool = false
			for _c in _tile.get_children():
				if _c is ConsumerResolveBehavior:
					var _consumer = _c as ConsumerResolveBehavior
					if _consumer.identifier != identifier:
						continue
					
					_net_resources += _consumer.amount
					_did_consume = true
			
			if _did_consume:
				_tile.apply_damage(get_damage_amount(_tile))
			
			if _net_resources >= 0:
				return

func get_damage_amount(_tile : Tile) -> int:
	return base_amount
