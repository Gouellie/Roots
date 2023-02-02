extends TileMap

const WATER_TILE_INDEX :int= 0
const NUTRIENT_TILE_INDEX :int= 1
const ROCK_TILE_INDEX :int= 2

const WATER_SCENE :PackedScene= preload("res://src/scenes/librairies/ingredients/water.tscn")
const NUT_SCENE :PackedScene= preload("res://src/scenes/librairies/ingredients/nutrient.tscn")
const ROCKWATER_SCENE :PackedScene= preload("res://src/scenes/librairies/ingredients/rock.tscn")


func _ready() -> void:
	var tile_offset = cell_size / 2
	for pos in get_used_cells():
		var cellv :int= get_cellv(pos)
		var real_pos = map_to_world(pos)
		var _scene = _get_scene(cellv)
		if _scene == null:
			continue
		var ingredient = _scene.instance() as Entity
		ingredient.position = real_pos + tile_offset
		add_child(ingredient)


func _get_scene(cellv : int) -> PackedScene:
		match cellv:
			WATER_TILE_INDEX:
				return WATER_SCENE
			NUTRIENT_TILE_INDEX:
				return NUT_SCENE
			ROCK_TILE_INDEX:
				return ROCKWATER_SCENE
		return null
