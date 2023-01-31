extends Node2D
class_name EntityManager

export (NodePath) var terrain_node_path


var _terrain : TileMap
var _selected_tile


func _ready() -> void:
	_terrain = get_node(terrain_node_path) as TileMap
	Events.connect("tile_selected", self, "on_tile_selected")


func on_tile_selected(new_selected_tile : Object)-> void:
#	if _selected_tile:
#		_selected_tile.queue_free()
	_selected_tile = new_selected_tile
