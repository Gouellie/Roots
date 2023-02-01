extends Entity
class_name Plant

export (NodePath) var terrain_node_path

onready var head_tile_cellv

func _ready() -> void:
	if terrain_node_path:
		var terrain = get_node(terrain_node_path) as TileMap
		cellv = terrain.world_to_map(position)
		head_tile_cellv = cellv
		head_tile_cellv.y += 1


func _get_network_head() -> Entity:
	for area in $Area2D.get_overlapping_areas():
		if area.owner is Entity:
			return area.owner
	return null
