extends ColorRect
class_name TilePanel

export (PackedScene) var tile_scene

const mouse_over := Color.yellow
const selected_color := Color.green

var is_selected : bool = false setget set_is_selected

export var random_tile : bool = true
export var tile_index : int = 0

onready var default := color
onready var tile_blueprint : TileBlueprint


func _ready() -> void:
	tile_blueprint = tile_scene.instance() as TileBlueprint
	tile_blueprint.tile_index = randi()%4+1 if random_tile else tile_index
	tile_blueprint.scale = Vector2(0.7, 0.7)
	tile_blueprint.position = $TileCenterPos.rect_position
	add_child(tile_blueprint)


func _on_TilePanel_mouse_entered() -> void:
	color = mouse_over


func _on_TilePanel_mouse_exited() -> void:
	color = selected_color if is_selected else default


func _on_TilePanel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed :
			set_is_selected(!is_selected)
			Events.emit_signal("tilepanel_selected", self, tile_blueprint if is_selected else null)


func set_is_selected(value : bool) -> void:
	is_selected = value
	if is_selected and tile_blueprint:
		color = selected_color
	else:
		color = default
