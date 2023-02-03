extends Popup


func _ready() -> void:
	connect("popup_hide", self, "on_closed")
	Events.connect("open_plant_shop", self, "on_open_plant_shop")


func on_open_plant_shop() -> void:
	Globals.is_upgrade_menu_opened = false	
	popup()


func on_closed() -> void:
	Globals.is_upgrade_menu_opened = false
