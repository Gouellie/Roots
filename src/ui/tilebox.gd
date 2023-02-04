extends Panel

export var max_tiles_count : int = 10

const tile_panel_scene := preload("res://src/ui/tilepanel.tscn")

var selection : TilePanel

onready var tile_container := $MarginContainer/TileContainer


func _ready() -> void:
	Events.connect("tilepanel_selected", self, "on_selected_tile_changed")
	Events.connect("shop_draw_tiles", self, "on_draw_tiles")
	Turns.connect("turn_next", self, "on_next_turn")
	Events.connect("tile_placed", self, "on_tile_placed")
	_draw_first_hand()


func on_selected_tile_changed(new_selection : TilePanel, tile : TileBlueprint) -> void:
	if selection == new_selection:
		return
	if selection :
		selection.is_selected = false
	selection = new_selection


func _draw_first_hand() -> void:
	var original_hand := [1,1,2,3,3,4]
	original_hand.shuffle()
	for i in range(Globals.BASE_TILES_DRAW_COUNT):
		var new_tile = tile_panel_scene.instance()
		new_tile.random_tile = false
		new_tile.tile_index = original_hand[i]
		tile_container.add_child(new_tile) 


func _draw_tiles() -> void:
	var tiles_count = tile_container.get_child_count()
	var draw_amount = Globals.get_tile_draw_amount()
	var burn = max((draw_amount + tiles_count) - max_tiles_count, 0)

	for i in range(burn - 1, -1, -1):
		var child = tile_container.get_child(i)
		tile_container.remove_child(child)
		child.queue_free()

	for i in range(draw_amount):
		var new_tile = tile_panel_scene.instance()
		tile_container.add_child(new_tile)


func on_tile_placed(tile) -> void:
	if is_instance_valid(selection):
		selection.queue_free()
		selection = null


func _on_Button_Erase_pressed() -> void:
	on_selected_tile_changed(null, null)
	Events.emit_signal("eraser_mode_toggled")


func on_next_turn(turn) -> void:
	_draw_tiles()
	
	
func on_draw_tiles() -> void:
	_draw_tiles()


func _on_Button_Erase_mouse_entered() -> void:
	var info = Info.new("Eraser Tool")
	info.add_info("Use eraser tool to remove tiles")
	Events.emit_signal("info_request",info)
