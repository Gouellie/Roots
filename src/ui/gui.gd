extends Control


onready var control_game_over := $Control_GameOver


func _ready() -> void:
	control_game_over.visible = false
	Events.connect("game_over", self, "on_game_over")


func on_game_over() -> void:
	control_game_over.visible = true


func _on_Button_Quit_pressed() -> void:
	var res = get_tree().change_scene("res://src/screens/main_menu.tscn")
	Log.log_error(res, "gui.gd")


func _on_Button_Retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_Button_Tick_pressed() -> void:
	Events.emit_signal("tick")
