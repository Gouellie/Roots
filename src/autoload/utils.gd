extends Node

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


static func get_tile_name(tile_map : TileMap, cellv : Vector2) -> String:
	var value = tile_map.get_cellv(cellv)
	return tile_map.tile_set.tile_get_name(value)
