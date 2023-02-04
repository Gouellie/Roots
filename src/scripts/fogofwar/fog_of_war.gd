extends TileMap
class_name FogOfWar


enum BRUSH_SIZE {
	small,
	medium,
	large,
}

const GRID_SIZE = 8

export (NodePath)var terrain_node_path
export(BRUSH_SIZE) var LIGHT_SIZE = BRUSH_SIZE.small

var light_texture 
var display_width = ProjectSettings.get("display/window/size/width")
var display_height = ProjectSettings.get("display/window/size/height")

var fog_image = Image.new()
var fog_texture = ImageTexture.new()

var light_image
var light_offset 

var terrain_tiles : Array

func _init():
	Events.connect("tile_placed", self, "on_tile_placed")
	Turns.connect("turn_next", self, "on_next_turn")
	Events.connect("init_entity_manager", self, "on_init_entity_manager")
	Events.connect("tile_removed_at", self, "on_tile_removed_at")

func on_init_entity_manager(_entity_manager : EntityManager):
	evaluate_all_tiles()


func _ready():
	var _t : TileMap = get_node(terrain_node_path) as TileMap
	terrain_tiles = _t.get_used_cells()
	reload_fog()


func reload_fog():
	for _v in terrain_tiles:
		var _v_above = Vector2(_v.x, _v.y-1)
		var _has_tile_above : bool = terrain_tiles.has(_v_above)
		
		update_fog(_v, not _has_tile_above)
	
	
func update_fog(_new_grid_position : Vector2, _visible : bool):
	var _index = 0
	if _visible:
		_index = 1
		
	set_cellv(_new_grid_position, _index)
	if Globals.entity_manager == null:
		return
		
	var _ing : Ingredient = Globals.ingredient_manager.get_ingredient_at(_new_grid_position)
	if _ing:
		_ing.set_fog_revealed(_visible)


func on_tile_placed(_tile : Tile):
	for _v2 in get_circle_around(_tile.cellv, _tile.fog_reveal_radius):
		update_fog(_v2, true)


func on_next_turn(_turn):
	evaluate_all_tiles()


func on_tile_removed_at(_cellv : Vector2):
	evaluate_all_tiles()

func evaluate_all_tiles():
	reload_fog()
		
	for _tile in Globals.entity_manager.tiles.values():
		for _v2 in get_circle_around(_tile.cellv, _tile.fog_reveal_radius):
			update_fog(_v2, true)

func get_circle_around(_from : Vector2, _distance : int) -> Array:
	var _tiles : Array = []
	for x in range(-_distance, _distance):
		for y in range(-_distance, _distance):
			var _distance_from_origin = abs(x) + abs(y)
			
			if _distance_from_origin >= _distance:
				continue
			_tiles.append(Vector2(_from.x + x, _from.y + y))
		
	return _tiles

func get_square_around(_from : Vector2, _distance : int) -> Array:
	var _tiles : Array = []
	for x in range(-_distance, _distance):
		for y in range(-_distance, _distance):
			_tiles.append(Vector2(_from.x + x, _from.y + y))
		
	return _tiles
