extends Entity
class_name Plant

export (NodePath) var terrain_node_path

var head_tile_cellv : Vector2


func _ready() -> void:
	if terrain_node_path:
		var terrain = get_node(terrain_node_path) as TileMap
		cellv = terrain.world_to_map(position)
		head_tile_cellv = cellv
		head_tile_cellv.y += 1


func _on_step_resolved(_step):
	# setup resolve steps no the Plant.scene, handle logic here
	pass
