extends Control
class_name SeasonUI


var season_manager : SeasonManager

onready var season_label = $ProgressBar/SeasonLabel
onready var progress_bar = $ProgressBar


func _init():
	Events.connect("init_season_manager", self, "on_season_manager_init")
	Events.connect("season_changed", self, "on_season_changed")
	Turns.connect("turn_next", self, "on_next_turn")
	

func on_season_manager_init(_season_manager):
	season_manager = _season_manager
	
func on_season_changed(_season):
	update_season()


func get_turns_til_next_season() -> int:
	return Globals.season_manager.get_turns_til_next_season()

func update_season():
	season_label.text = season_manager.season
	progress_bar.value = 0
	progress_bar.max_value = get_turns_til_next_season()

func on_next_turn(turn):
	progress_bar.value += 1


func _on_SeasonUI_mouse_entered() -> void:
	season_manager.display_info()


func _on_SeasonUI_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Events.emit_signal("display_season_notif", season_manager.season)
