extends Popup


func _ready() -> void:
	Events.connect("open_plant_shop", self, "on_open_plant_shop")


func on_open_plant_shop() -> void:
	popup()


func _on_Button_Close_pressed() -> void:
	visible = false

