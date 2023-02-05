extends Control
class_name SeasonUI


var season_manager : SeasonManager

onready var season_label = $SeasonLabel


func _init():
	Events.connect("init_season_manager", self, "on_season_manager_init")
	Events.connect("season_changed", self, "on_season_changed")
	

func on_season_manager_init(_season_manager):
	season_manager = _season_manager
	
func on_season_changed(_season):
	update_season()


func update_season():
	season_label.text = season_manager.season
