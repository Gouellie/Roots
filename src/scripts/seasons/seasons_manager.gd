extends Node2D
class_name SeasonManager

var season : String = "" setget set_season

func _init():
	Turns.connect("turn_next", self, "on_next_turn")

func _ready():
	Events.emit_signal("init_season_manager", self)

	
func on_next_turn(_turn):
	process_turn()

func process_turn():
	var _turn : int = Globals.turn_manager.turn
	if Globals.SEASON_CONFIG.has(_turn) == false:
		return
	
	set_season(Globals.SEASON_CONFIG[_turn])

func set_season(_season : String):
	if season == _season:
		return
		
	season = _season
	Events.emit_signal("season_changed", season)


func get_next_season() -> String:
	match season:
		"winter": return "spring"
		"spring": return "summer"
		"summer": return "autumn"
		"autumn": return "winter"
	
	return ""

func get_turns_til_next_season() -> int:
	for _turns in Globals.SEASON_CONFIG:
		if Globals.SEASON_CONFIG[_turns] == get_next_season():
			return _turns - Globals.turn_manager.turn
	
	return 0
