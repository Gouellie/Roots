extends TileMap
class_name IngredientManager

const WATER_TILE_INDEX :int= 0
const NUTRIENT_TILE_INDEX :int= 1
const ROCK_TILE_INDEX :int= 2
const ROOT_TILE_INDEX :int= 3
const SOIL_TILE_INDEX :int= 4

const WATER_SCENE : PackedScene= preload("res://src/scenes/librairies/ingredients/water.tscn")
const NUT_SCENE : PackedScene= preload("res://src/scenes/librairies/ingredients/soil.tscn")
const ROCK_SCENE : PackedScene= preload("res://src/scenes/librairies/ingredients/rock.tscn")
const ROOT_SCENE : PackedScene= preload("res://src/scenes/librairies/ingredients/dead_root.tscn")
const SOIL_SCENE : PackedScene= preload("res://src/scenes/librairies/ingredients/fertile_soil.tscn")


const scenes := {
	WATER_TILE_INDEX : WATER_SCENE,
	NUTRIENT_TILE_INDEX : NUT_SCENE,
	ROCK_TILE_INDEX : ROCK_SCENE,
	ROOT_TILE_INDEX : ROOT_SCENE,
	SOIL_TILE_INDEX : SOIL_SCENE,
}


onready var ingredients := {}


func _init() -> void:
	Events.emit_signal("init_ingredient_manager", self)	


func _ready() -> void:
	var tile_offset = cell_size / 2
	for pos in get_used_cells():
		var cellv :int= get_cellv(pos)
		var real_pos = map_to_world(pos)
		if not scenes.has(cellv):
			continue
		var _scene = scenes[cellv]
		if _scene == null:
			continue
		var ingredient = _scene.instance() as Entity
		ingredient.position = real_pos + tile_offset
		add_child(ingredient)
		ingredients[pos] = ingredient
	clear()


func is_cell_occupied(cellv: Vector2) -> bool:
	return ingredients.has(cellv)


func get_ingredient_at(pos : Vector2) -> Ingredient:
	if ingredients.has(pos):
		return ingredients[pos]
	return null
