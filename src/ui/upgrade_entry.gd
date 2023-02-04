extends Control

export (String) var upgrade_name
export (String) var details
export (PoolStringArray) var extra_info
export (int) var base_price := 1
export (int) var max_level := 6
export (int) var max_price := 20
export (bool) var once_per_turn
export (int) var fibo_mod := 0
export (String) var signal_to_emit 

const fibo := [1, 2, 3, 5, 8, 13, 21, 34]

var infinite : bool = false
var current_level : int = 0
var current_price : int

onready var label_name := $MarginContainer/VBoxContainer/HBoxContainer_Header/Label_UpgradeName
onready var label_level := $MarginContainer/VBoxContainer/HBoxContainer_Header/Label_Level
onready var label_details := $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Label_Details
onready var label_price := $MarginContainer/VBoxContainer/HBoxContainer/Label_Price
onready var button : Button = $MarginContainer/VBoxContainer/HBoxContainer/Button_Buy


func _ready() -> void:
	Events.connect("open_plant_shop", self, "on_upgrade_shop_open")
	Events.connect("shop_upgrade_bought", self, "on_upgrade_bought")
	current_price = base_price
	label_name.text = upgrade_name
	label_details.text = details
	label_price.text = "x%d" % current_price
	if max_level < 0:
		infinite = true
	_update_level_text()


func _on_Button_Buy_pressed() -> void:
	if not _try_buying():
		return
	Events.emit_signal("shop_upgrade_bought")
	if infinite:
		Events.emit_signal(signal_to_emit)
		return
	current_level += 1
	Events.emit_signal(signal_to_emit, current_level)
	if current_level == max_level:
		button.disabled = true
		label_price.visible = false
	current_price = base_price + fibo[current_level + fibo_mod]
	current_price = min(current_price, max_price) as int
	label_price.text = "x%d" % current_price
	_update_level_text()
	
	
func _update_level_text() -> void:
	if infinite:
		label_level.text = ""
	else:
		label_level.text = "%d/%d" % [current_level, max_level]


func on_upgrade_shop_open() -> void:
	_check_if_can_buy()


func on_upgrade_bought() -> void:
	_check_if_can_buy()


func _check_if_can_buy() -> void:
	var can_buy = Globals.player_resource_manager.get_resource_manager().can_consume(Resources.SUNLIGHT, current_price)
	button.disabled = not can_buy	


func _try_buying() -> bool:
	return Globals.player_resource_manager.get_resource_manager().try_consume(Resources.SUNLIGHT, current_price)


func _on_MarginContainer_mouse_entered() -> void:
	var info = Info.new(upgrade_name)
	for i in extra_info:
		info.add_info(i)
	Events.emit_signal("info_request", info)
