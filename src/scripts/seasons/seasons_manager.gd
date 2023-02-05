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
	print("season changed")
