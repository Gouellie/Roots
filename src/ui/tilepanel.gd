extends ColorRect
class_name TilePanel

export (PackedScene) var tile_scene

const mouse_over := Color.yellow
const selected_color := Color.green
const insufficient_resources := Color.red

var is_hovering : bool = false
var is_selected : bool = false setget set_is_selected

export var random_tile : bool = true
export var tile_index : int = 0

onready var default := color
onready var tile_blueprint : TileBlueprint

func _init():
	Events.connect("init_player_resource_manager", self, "on_init_player_resource_manager")
	Events.connect("tile_placed", self, "on_tile_placed")

func on_init_player_resource_manager(_player_resource_manager):
	for _rsc in Globals.player_resource_manager.get_resource_manager().get_all_resources():
		var _node = _rsc as ResourceNode
		if _node == null:
			continue
		
		_node.connect("node_update", self, "on_resource_updated")
		
func _ready() -> void:
	tile_blueprint = tile_scene.instance() as TileBlueprint
	tile_blueprint.tile_index = randi()%4+1 if random_tile else tile_index
	tile_blueprint.scale = Vector2(0.5, 0.5)
	tile_blueprint.position = $TileCenterPos.rect_position
	add_child(tile_blueprint)

func on_resource_updated():
	update_color()

func on_tile_placed(_tile):
	update_color()

func update_color():
	if tile_blueprint.can_afford() == false:
		color = insufficient_resources
		return
		
	if is_hovering:
		color = mouse_over
		return
		
	if is_selected and tile_blueprint:
		color = selected_color
		return
		
	color = default

func _on_TilePanel_mouse_entered() -> void:
	is_hovering = true
	update_color()
	var info = Info.new("Tile")
	info.add_info("Connect the tile to your root network")
	Events.emit_signal("info_request", info)


func _on_TilePanel_mouse_exited() -> void:
	is_hovering = false
	update_color()

func _on_TilePanel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed :
			set_is_selected(!is_selected)
			Events.emit_signal("tilepanel_selected", self, tile_blueprint if is_selected else null)

func set_is_selected(value : bool) -> void:
	if tile_blueprint.can_afford() == false:
		is_selected = false
		return
	else:
		is_selected = value
		
	update_color()
		
	
