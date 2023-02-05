extends ResourceResolveBehavior
class_name ConsumerResolveBehavior

var season_modifiers : int = 0

func _init():
	._init()
	resolve_step = Turns.STEP_ORDER.resources_consume
	Events.connect("season_changed", self, "on_season_changed")

func _ready():
	update_season()
	
	
func _execute_resolve_behavior():
	Globals.player_resource_manager.get_resource_manager().deduct_from_resource(identifier, get_amount())


func get_amount() -> int:
	return amount + season_modifiers


func update_season():
	if Globals.SEASON_CONSUMPTION_MODIFIER.has(Globals.season_manager.season) == false:
		season_modifiers = 0
		return
		
	var _config : Dictionary = Globals.SEASON_CONSUMPTION_MODIFIER[Globals.season_manager.season]
	if _config.has(identifier):
		season_modifiers = _config[identifier]


func on_season_changed(_season):
	update_season()
