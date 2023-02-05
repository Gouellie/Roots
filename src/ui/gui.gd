extends Control


onready var game_control := $GameControlScreen
onready var confirm_control := $GameControlScreen_Confirm
onready var header = $GameControlScreen/Panel/CenterContainer/VBoxContainer/Header
onready var description = $GameControlScreen/Panel/CenterContainer/VBoxContainer/Description

onready var button_quit_to_desktop := $GameControlScreen/Panel/CenterContainer/VBoxContainer/Button_QuitToDeskop

onready var button_shop := $Margin/Control_ButtonShop/Button_OpenShop

func _ready() -> void:
	button_shop.disabled = true
	game_control.visible = false
	button_quit_to_desktop.visible = not Utils.in_web_browser()
	Events.connect("game_over", self, "on_game_over")
	Events.connect("victory", self, "on_game_victory")
	Events.connect("num_plants_changed", self, "on_first_plant_placed")


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
	confirm_control.visible = true


func _on_Button_QuitToDeskop_pressed() -> void:
	get_tree().quit()


func _on_Button_Confirm_pressed() -> void:
	confirm_control.visible = false
	game_control.visible = true
	header.text = "GAME OVER"
	description.text = "You gave up"


func _on_Button_Cancel_pressed() -> void:
	confirm_control.visible = false


func _on_Button_OpenShop_pressed() -> void:
	Events.emit_signal("open_plant_shop")


func on_first_plant_placed(num) -> void:
	if num < Globals.NUMB_PLANT_PLACED_TO_OPEN_STORE:
		return
	Events.disconnect("num_plants_changed", self, "on_first_plant_placed")
	button_shop.disabled = false


func _on_Button_OpenShop_mouse_entered() -> void:
	var info = Info.new("Upgrades Shop")
	info.add_info("Spend your Sunlight here to buy permanents upgrades")
	if button_shop.disabled:
		info.add_info("Available once you've grown %d extra plants" % Globals.NUMB_PLANT_PLACED_TO_OPEN_STORE, 1)
	Events.emit_signal("info_request", info)
