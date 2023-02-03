extends Control


onready var game_control := $GameControlScreen
onready var header = $GameControlScreen/Panel/CenterContainer/VBoxContainer/Header
onready var description = $GameControlScreen/Panel/CenterContainer/VBoxContainer/Description


func _ready() -> void:
	game_control.visible = false
	Events.connect("game_over", self, "on_game_over")
	Events.connect("victory", self, "on_game_victory")


func on_game_over(behavior) -> void:
	header.text = "GAME OVER"
	game_control.visible = true
	
	if behavior is ConditionLoseResolveBehavior:
		description.text = behavior.description


func on_game_victory(behavior) -> void:
	header.text = "VICTORY"
	game_control.visible = true
	
	if behavior is ConditionWinResolveBehavior:
		description.text = behavior.description


func _on_Button_Quit_pressed() -> void:
	var res = get_tree().change_scene("res://src/screens/main_menu.tscn")
	Log.log_error(res, "gui.gd")


func _on_Button_Retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_Button_GiveUp_pressed() -> void:
	game_control.visible = true
	header.text = "GAME OVER"
	description.text = "You gave up"
	
