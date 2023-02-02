extends ResolveBehavior
class_name DamageResolveBehavior

var tile : Tile
export var base_amount : int = 1

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.roots_damage
	
func _ready():
	if get_owner() is Tile:
		tile = get_owner() as Tile
	
func _execute_resolve_behavior():
	if Globals.
	if Globals.entity_manager.should_receive_damage(tile) == false:
		return
	
	tile.apply_damage(get_damage_amount())
	
func get_damage_amount() -> int:
	return base_amount
