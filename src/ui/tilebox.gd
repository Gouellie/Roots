extends Panel

export var max_tiles_count : int = 5

const tile_panel_scene := preload("res://src/ui/tilepanel.tscn")

var selection : TilePanel

onready var tile_container := $CenterContainer/TileContainer


func _ready() -> void:
	Events.connect("tilepanel_selected", self, "on_selected_tile_changed")
	Events.connect("tile_placed", self, "on_tile_placed")


func on_selected_tile_changed(new_selection : TilePanel, tile : TileBlueprint) -> void:
	if selection == new_selection:
		return
	if selection :
		selection.is_selected = false
	selection = new_selection


func _on_Button_DrawTile_pressed() -> void:
	if tile_container.get_child_count() > max_tiles_count:
		return
	var new_tile = tile_panel_scene.instance()
	tile_container.add_child(new_tile)


func on_tile_placed(tile) -> void:
	if is_instance_valid(selection):
		selection.queue_free()
		selection = null


func _on_Button_Erase_pressed() -> void:
	on_selected_tile_changed(null, null)
	Events.emit_signal("eraser_mode_toggled")
