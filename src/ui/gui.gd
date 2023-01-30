extends Control


func _ready() -> void:
	pass


func _on_Button_Quit_pressed() -> void:
	var res = get_tree().change_scene("res://src/screens/main_menu.tscn")
	Log.log_error(res, "gui.gd")
