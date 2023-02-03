extends ResolveBehavior
class_name SeveredConnectionDamageResolveBehavior

var tile : Tile
export var base_amount : int = 1

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.roots_damage_severed
	
func _ready():
	if get_owner() is Tile:
		tile = get_owner() as Tile
	
func _execute_resolve_behavior():
	if tile.connected:
		return
	
	tile.apply_damage(get_damage_amount())
	
func get_damage_amount() -> int:
	return base_amount
