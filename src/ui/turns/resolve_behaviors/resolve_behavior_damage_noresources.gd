extends ResolveBehavior
class_name NoResourcesDamageResolveBehavior

var tile : Tile
export (String)var identifier : String = "water"
export var base_amount : int = 1

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.roots_damage_connected
	
func _ready():
	if get_owner() is Tile:
		tile = get_owner() as Tile
	
func _execute_resolve_behavior():
	var rsc : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource(identifier) as ResourceNode
	if rsc == null || rsc._is_depleted() == false:
		return
		
	if Globals.entity_manager.should_receive_damage(tile) == false:
		return
	
	tile.apply_damage(get_damage_amount())
	
func get_damage_amount() -> int:
	return base_amount
