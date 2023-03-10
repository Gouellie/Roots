extends TileMap
class_name FogManager


export (NodePath)var terrain_node_path
export (NodePath)var master_plant_node_path

var terrain_tiles : Array
var fog_tiles : Array
var master_plant : Plant
var master_plant_tiles : Array


func _init():
	Events.connect("tile_placed", self, "on_tile_placed")
	Turns.connect("turn_next", self, "on_next_turn")
	Events.connect("init_entity_manager", self, "on_init_entity_manager")
	Events.connect("tile_removed_at", self, "on_tile_removed_at")
	
	Events.emit_signal("init_fog_manager", self)

func on_init_entity_manager(_entity_manager : EntityManager):
	Events.connect("main_scene_loaded", self, "on_main_scene_loaded")


func _ready():
	var _t : TileMap = get_node(terrain_node_path) as TileMap
	terrain_tiles = _t.get_used_cells()
	reload_fog()
	master_plant = get_node(master_plant_node_path) as Plant


func on_main_scene_loaded() -> void:
	master_plant_tiles = get_circle_around(master_plant.cellv, Globals.FOG_REVEAL_RADIUS_MASTER_PLANT)
	evaluate_all_tiles()


func reload_fog():
	fog_tiles.clear()
	for _v in terrain_tiles:
		var _v_above = Vector2(_v.x, _v.y-1)
		var _has_tile_above : bool = terrain_tiles.has(_v_above)
		
		update_fog(_v, not _has_tile_above)
		if not _has_tile_above:
			fog_tiles.append(_v)
	
	
func update_fog(_new_grid_position : Vector2, _visible : bool):
	if _visible:
		if fog_tiles.has(_new_grid_position):
			fog_tiles.remove(fog_tiles.find(_new_grid_position))
			set_cellv(_new_grid_position, TileMap.INVALID_CELL)
	else:
		if not fog_tiles.has(_new_grid_position):
			set_cellv(_new_grid_position, 0)
			fog_tiles.append(_new_grid_position)
		
	
	if Globals.entity_manager == null:
		return
		
	var _ing : Ingredient = Globals.ingredient_manager.get_ingredient_at(_new_grid_position)
	if _ing:
		_ing.set_fog_revealed(_visible)


func unfog_master_plant(_mp : Plant):
	for _v2 in get_circle_around(_mp.cellv, Globals.FOG_REVEAL_RADIUS_MASTER_PLANT):
		update_fog(_v2, true)


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

	for _v2 in master_plant_tiles:
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
	
	
func has_fog_at(pos : Vector2) -> bool:
	return fog_tiles.has(pos)
	
