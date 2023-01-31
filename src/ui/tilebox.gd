extends Panel

export var max_tiles_count : int = 5

const tile_panel_scene := preload("res://src/ui/tilepanel.tscn")

var selection : TilePanel

onready var tile_container := $CenterContainer/TileContainer


func _ready() -> void:
	Events.connect("tile_selected", self, "on_selected_tile_changed")


func on_tile_drawn(new_tile) -> void:
	pass


func on_selected_tile_changed(new_selection : TilePanel) -> void:
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
