extends Panel


func _ready() -> void:
	Events.connect("open_plant_shop", self, "on_open_plant_shop")
	Events.connect("close_plant_shop", self, "on_close_plant_shop")


func on_open_plant_shop() -> void:
	Globals.is_upgrade_menu_opened = true	
	visible = true

func on_close_plant_shop() -> void:
	visible = false
	Globals.is_upgrade_menu_opened = false
	Events.emit_signal("plant_shop_closed")	


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventMouse:
		_display_info()
	if event is InputEventMouseButton:
		on_close_plant_shop()


var wait_until_next_request : bool

func _display_info() -> void:
	if wait_until_next_request:
		return
	wait_until_next_request = true
	var info = Info.new("Upgrades Shop")
	info.add_info("Spend your Sunlight here to buy permanents upgrades")
	Events.emit_signal("info_request", info)
	yield(get_tree().create_timer(1.0), "timeout")
	wait_until_next_request = false


func _on_MarginContainer_mouse_entered() -> void:
	_display_info()
