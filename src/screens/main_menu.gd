extends Control

onready var button_quit : Button = $HBoxContainer/Button_Quit


func _ready() -> void:
	if OS.get_name() == "HTML5":
		button_quit.visible = false
	

func _on_Button_NewGame_pressed() -> void:
	var res = get_tree().change_scene("res://src/scenes/main_scene.tscn")
	Log.log_error(res, "main_menu.gd")


func _on_Button_Quit_pressed() -> void:
	get_tree().quit()
