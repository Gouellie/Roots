extends Node

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


static func set_children_visible(node : Node, visible : bool):
	for n in node.get_children():
		n.visible = visible


static func get_tile_name(tile_map : TileMap, value : int) -> String:
	return tile_map.tile_set.tile_get_name(value)


static func get_tile_name_at_position(tile_map : TileMap, cellv : Vector2) -> String:
	var value = tile_map.get_cellv(cellv)
	return tile_map.tile_set.tile_get_name(value)


static func in_web_browser() -> bool:
	return OS.get_name() == "HTML5"
