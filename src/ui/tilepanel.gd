extends ColorRect
class_name TilePanel

export (PackedScene) var tile_scene

const mouse_over := Color.yellow
const selected_color := Color.green

var is_selected : bool = false setget set_is_selected

onready var default := color


func _ready() -> void:
	if tile_scene:
		var tile = tile_scene.instance() as TileBase
		tile.scale = Vector2(0.7, 0.7)
		tile.position = $TileCenterPos.rect_position
		add_child(tile)


func _on_TilePanel_mouse_entered() -> void:
	color = mouse_over


func _on_TilePanel_mouse_exited() -> void:
	color = selected_color if is_selected else default


func _on_TilePanel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed :
			set_is_selected(!is_selected)


func set_is_selected(value : bool) -> void:
	is_selected = value
	if is_selected:
		color = selected_color
		Events.emit_signal("tile_selected", self)
	else:
		color = default
