extends CanvasLayer

onready var button_quit : Button = $HBoxContainer/Button_Quit


func _ready() -> void:
	button_quit.visible = not Utils.in_web_browser()
	

func _on_Button_NewGame_pressed() -> void:
	var res = get_tree().change_scene("res://src/scenes/main_scene.tscn")
	Log.log_error(res, "main_menu.gd")


func _on_Button_Quit_pressed() -> void:
	get_tree().quit()
