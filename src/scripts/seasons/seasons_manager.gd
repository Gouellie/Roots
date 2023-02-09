extends Node2D
class_name SeasonManager

var season : String = "" setget set_season,get_season

func _init():
	Turns.connect("turn_next", self, "on_next_turn")

func _ready():
	Events.emit_signal("init_season_manager", self)
	season = Globals.SEASON_CONFIG[1]

	
func on_next_turn(_turn):
	process_turn()

func process_turn():
	var _turn : int = Globals.turn_manager.turn
	var modulated_turn = wrapi(_turn, 1, Globals.TURNS_PER_SEASON_CYCLES)
	if not Globals.SEASON_CONFIG.has(modulated_turn):
		return
	set_season(Globals.SEASON_CONFIG[modulated_turn])


func set_season(_season : String):
	if season == _season:
		return
		
	season = _season
	Events.emit_signal("season_changed", season)

func get_season() -> String:
	return season


func get_next_season() -> String:
	match season:
		"summer": return "autumn"
		"autumn": return "winter"
		"winter": return "spring"
		# commenting out spring and using the TURNS_PER_SEASON_CYCLES as the rollover
		#"spring": return "summer"
	return ""


func get_turns_til_next_season() -> int:
	for _turns in Globals.SEASON_CONFIG:
		if Globals.SEASON_CONFIG[_turns] == get_next_season():
			return _turns - wrapi(Globals.turn_manager.turn, 1, Globals.TURNS_PER_SEASON_CYCLES)
	return Globals.TURNS_PER_SEASON_CYCLES - wrapi(Globals.turn_manager.turn, 1, Globals.TURNS_PER_SEASON_CYCLES)


func display_info() -> void:
	var mods = Globals.SEASON_CONSUMPTION_MODIFIER[season]
	if not mods is Dictionary:
		return
	var info = Info.new(Globals.SEASON_NAME[season])
	if mods.empty():
		info.add_info("Your Plants and Roots don't require extra Soil and Water")
	if mods.has("soil"):
		info.add_info("Plants requires +%d Soil" % mods["soil"])
	if mods.has("water"):
		info.add_info("Roots requires +%d Water" % mods["water"])
	Events.emit_signal("info_request", info)
