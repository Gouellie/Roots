extends Panel

onready var music :Button= $MarginContainer/VBoxContainer/CheckButton_Music
onready var sfx :Button= $MarginContainer/VBoxContainer/CheckButton_SFX

func _ready() -> void:
	music.pressed = not AudioServer.is_bus_mute(AudioScene.BUSES.BUS_MUSIC)
	music.text = "Music ON" if music.pressed else "Music OFF"
	sfx.pressed = not AudioServer.is_bus_mute(AudioScene.BUSES.BUS_SFX)
	sfx.text = "SFX ON" if sfx.pressed else "SFX OFF"
	Events.connect("open_settings", self, "on_open_settings")
	Events.connect("close_settings", self, "on_close_settings")


func on_open_settings() -> void:
	visible = true

	
func on_close_settings() -> void:
	visible = false
	Events.emit_signal("settings_closed")


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventMouseButton:
		on_close_settings()


func _on_Button_GiveUp_pressed() -> void:
	Events.emit_signal("give_up")


func _on_CheckButton_Music_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(AudioScene.BUSES.BUS_MUSIC, not button_pressed)
	music.text = "Music ON" if button_pressed else "Music OFF"


func _on_CheckButton_SFX_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(AudioScene.BUSES.BUS_SFX, not button_pressed)
	sfx.text = "SFX ON" if button_pressed else "SFX OFF"

