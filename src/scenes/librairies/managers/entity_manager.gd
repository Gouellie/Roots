extends Node2D
class_name EntityManager

export (NodePath) var terrain_node_path
export (NodePath) var bedrock_node_path
export (NodePath) var plant_master_node_path

const plant_scene := preload("res://src/scenes/librairies/plants/plant.tscn")

const _eraser_scene := preload("res://src/scenes/librairies/tiles/blueprints/tile_eraser.tscn")

var tiles := {}

var _blueprint : TileBlueprint
var _eraser : TileBlueprintEraser
var _placeable_blueprint : bool
var _plants := {}
var step_resolver : StepResolver = StepResolver.new()

var builder_mode : bool = false
var eraser_mode : bool = false

# caching last mouse over cell to avoid spamming on mouse movement
var last_mouse_over_cell : Vector2

onready var _plant_master : Plant
onready var _terrain : TileMap
onready var _bedrock : TileMap
onready var tile_offset : Vector2

func _ready() -> void:
	_plant_master = get_node(plant_master_node_path) as Plant
	_terrain = get_node(terrain_node_path) as TileMap
	_bedrock = get_node(bedrock_node_path) as TileMap
	tile_offset = _terrain.cell_size / 2
	Events.connect("main_scene_loaded", self, "on_main_scene_loaded")
	Events.connect("tilepanel_selected", self, "on_tile_selected")
	Events.connect("eraser_mode_toggled", self, "oneraser_mode_toggled")
	Events.connect("spawn_plant", self, "on_spawn_plant")
	Events.emit_signal("init_entity_manager", self)
	Events.connect("consumption_amount_changed", self, "on_resource_consumption_changed")
	step_resolver.ready(self)


func _process(_delta: float) -> void:
	if not eraser_mode and not builder_mode:
		return
	_move_blueprint(get_global_mouse_position())


func on_main_scene_loaded() -> void:
	pass


func _move_blueprint(mouse_position: Vector2) -> void:
	var cellv = _terrain.world_to_map(mouse_position)
	var snap_position = _terrain.map_to_world(cellv) + tile_offset
	if eraser_mode and _eraser:
		_eraser.position = snap_position
	elif _blueprint:
		_blueprint.position = snap_position
		_blueprint.valid = _can_place_tile(cellv)


func on_tile_selected(sender : TilePanel, new_selected_blueprint : TileBlueprintBase)-> void:
	_clear_blueprint()
	if new_selected_blueprint:
		_seteraser_mode(false)
		var new_blueprint = new_selected_blueprint.duplicate() as TileBlueprintBase
		new_blueprint.scale = Vector2(1.0,1.0)
		add_child(new_blueprint)
		_placeable_blueprint = true
		_blueprint = new_blueprint

	builder_mode = new_selected_blueprint != null
	Events.emit_signal("building_mode_toggle", builder_mode)
	Events.emit_signal("tile_selected", _blueprint)

func oneraser_mode_toggled()-> void:
	_seteraser_mode(not eraser_mode)

func _seteraser_mode(value : bool) -> void:
	if eraser_mode == value:
		return
	eraser_mode = value
	if eraser_mode:
		_eraser = _eraser_scene.instance() as TileBlueprintBase
		add_child(_eraser)
		Events.emit_signal("building_mode_toggle", false)
	else:
		if is_instance_valid(_eraser):
			_eraser.queue_free()
			_eraser = null
	if is_instance_valid(_blueprint):
		_clear_blueprint()


func _unhandled_input(event: InputEvent) -> void:
	_emit_tile_info()
	if _blueprint:
		if event.is_action_pressed("rotate_cw"):
			_blueprint.rotate_blueprint(true)
		if event.is_action_pressed("rotate_ccw"):
			_blueprint.rotate_blueprint(false)
	
	
	if not event is InputEventMouseButton: 
		return
	if event.is_action_pressed("ui_select"):
		if _placeable_blueprint:
			_place_tile()
		elif eraser_mode:
			_remove_tile()

	if eraser_mode and event.is_action_pressed("ui_cancel"):
		_seteraser_mode(false)


func _emit_tile_info() -> void:
	if Globals.is_upgrade_menu_opened:
		return

	var cellv = _terrain.world_to_map(get_global_mouse_position())
	if cellv == last_mouse_over_cell:
		return
	last_mouse_over_cell = cellv		
	
	if _bedrock.get_cellv(cellv) != TileMap.INVALID_CELL:
		_bedrock_info()
		return
	
	if _plant_master.cellv == cellv:
		return
	if is_cell_occupied(cellv):
		return
	if Globals.ingredient_manager.is_cell_occupied(cellv):
		return
	
	if _plant_master.has_mouse:
		return

	for p in _plants.values():
		if p.has_mouse:
			return

	var tile_index = _terrain.get_cellv(cellv)
	if tile_index == TileMap.INVALID_CELL:
		Globals.display_game_info()
		return

	var tile_name = Utils.get_tile_name(_terrain, tile_index)
	
	var descriptions = Resources.get_terrain_descriptions(tile_name)
	var info = Info.new(descriptions["name"])
	var _i = 0
	for desc in descriptions["info"]:
		info.add_info(desc, _i)
		_i += 1
	Events.emit_signal("info_request", info)


func _bedrock_info() -> void:
	var info = Info.new("Bedrock")
	info.add_info("You have reached the edge of the map")
	info.add_info("Turn around or you will despawn!!", 1)
	info.add_info("jk", 1)
	Events.emit_signal("info_request", info)


func _can_place_tile(cellv : Vector2) -> bool:
	if _terrain.get_cellv(cellv) == TileMap.INVALID_CELL:
		return false
	var ing = Globals.ingredient_manager.get_ingredient_at(cellv)
	if ing is Ingredient and ing.is_blocking_tiles:
		return false
	return _blueprint.is_connected_to_network(get_tile_at_position(cellv))


func _place_tile() -> void:
	if not _blueprint is TileBlueprint:
		return
	if not _blueprint.valid:
		return
	if not _blueprint.try_consume():
		return

	Events.emit_signal("building_mode_toggle", false)
	builder_mode = false

	var cellv = _terrain.world_to_map(_blueprint.position)
	remove_tile_at_position(cellv)

	var new_tile = _blueprint.tile_scene.instance() as Tile
	new_tile.position = _blueprint.position
	new_tile.real_rotation = _blueprint.real_rotation
	
	_initiliaze_tile(new_tile, cellv)

	add_child(new_tile)
	Events.emit_signal("tile_placed", new_tile)
	_clear_blueprint()
	# physics takes a few frame before it registers overlapping areas... 
	yield(get_tree().create_timer(0.1), "timeout")
	_update_network_connection()


func _initiliaze_tile(tile : Tile, cellv : Vector2) -> void:
	tiles[cellv] = tile
	tile.cellv = cellv
	var tile_name = Utils.get_tile_name_at_position(_terrain, cellv)
	var tile_cost = Resources.get_terrain_cost(tile_name)
	assert(tile_cost != Resources.INVALID_TILE_COST, "Coulnd't retrieve tile cost from tile name : %s" % tile_name)
	tile.terrain_tile_cost = tile_cost
	

func deplete_tile(_tile : Tile):
	remove_tile_at_position(_tile.cellv)
	if _tile.connected:
		_update_network_connection()

func _remove_tile() -> void:
	var cellv = _terrain.world_to_map(_eraser.position)
	if is_cell_occupied(cellv):
		if remove_tile_at_position(cellv):
			_update_network_connection()
			
	Events.emit_signal("tile_removed_at", cellv)

func _clear_blueprint() -> void:
	_placeable_blueprint = false
	if is_instance_valid(_blueprint):
		_blueprint.queue_free()
		_blueprint = null

func remove_tile_at_position(cellv: Vector2) -> bool:
	if tiles.has(cellv):
		var tile = tiles[cellv]
		var result := tiles.erase(cellv)
		tile.queue_free()
		return result
	return false

func get_tile_at_position(cellv: Vector2) -> Tile:
	if tiles.has(cellv):
		return tiles[cellv] as Tile
	return null

func is_cell_occupied(cellv: Vector2) -> bool:
	return tiles.has(cellv)

func _update_network_connection() -> void:
	# assuming all tiles are disconnected
	for tile in tiles.values():
		if tile is Tile:
			tile.connected = false
			tile.distance = 999
	var head = get_network_head(_plant_master)
	# no head connected to flower means no good
	if not is_instance_valid(head):
		return
	if head.is_queued_for_deletion():
		return
	head.connected = true
	head.distance = 0
	_parse_network(head, 1)
	_update_plants()
	Events.emit_signal("tile_network_updated")
	
func _update_plants() -> void:
	for _p in _plants.values():
		_update_plant(_p)

func _update_plant(_plant : Plant) -> void:
	var head = get_network_head(_plant)
	# no head connected to flower means no good
	if not is_instance_valid(head):
		return
	if head.is_queued_for_deletion():
		return
	if not head.connected:
		_plant.connected = false
		return
	_plant.connected = true
	head.distance = 0		
	_parse_network(head, 1)

func _update_parche_preview():
	var _parche_tiles : Array = get_tiles_to_parche()
	for _t in tiles.values():
		if _t is Tile:
			var _tile = _t as Tile
			_tile.queued_parche = _parche_tiles.has(_tile) || _tile.connected == false
	
func get_plants_to_parche() -> Array:
	var _identifier = Resources.SOIL
	var rsc : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource(_identifier) as ResourceNode
	if rsc == null || rsc._is_depleted() == false:
		return []

	var _sorted_plants = _plants.values()
	_sorted_plants.sort_custom(self, "sort_distance_descending")
	
	var _consumption = Globals.player_resource_manager.get_consumption_amount_by_resource(_identifier)
	var _production = Globals.player_resource_manager.get_production_amount_by_resource(_identifier)
	var _net_resources : int = _production - _consumption
	
	if _net_resources >= 0:
		return []
	
	if _sorted_plants.size() == 0:
		return [_plant_master]
		
	var _i = 0
	var _parched_plants = []
	for _p in _sorted_plants:
		if _p is Plant:
			var _plant : Plant = _p as Plant
						
			var _did_consume : bool = false
			for _c in _plant.get_children():
				if _c is ConsumerResolveBehavior:
					var _consumer = _c as ConsumerResolveBehavior
					if _consumer.identifier != _identifier:
						continue
					
					_net_resources += _consumer.get_amount()
					_did_consume = true
			
			if _did_consume:
				_parched_plants.append(_plant)
			
			if _net_resources >= 0:
				return _parched_plants
	
	return _parched_plants
	
func get_tiles_to_parche() -> Array:
	var _identifier = Resources.WATER
	var rsc : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource(_identifier) as ResourceNode
	if rsc == null || rsc._is_depleted() == false:
		return []

	var _sorted_tiles : Array = get_tiles_sorted_by_distance()
	
	var _consumption = Globals.player_resource_manager.get_consumption_amount_by_resource(_identifier)
	var _production = Globals.player_resource_manager.get_production_amount_by_resource(_identifier)
	var _net_resources : int = _production - _consumption
	
	if _net_resources >= 0:
		return []
		
	var _i = 0
	var _parched_tiles = []
	for _t in _sorted_tiles:
		if _t is Tile:
			var _tile : Tile = _t as Tile
						
			var _did_consume : bool = false
			for _c in _tile.get_children():
				if _c is ConsumerResolveBehavior:
					var _consumer = _c as ConsumerResolveBehavior
					if _consumer.identifier != _identifier:
						continue
					
					_net_resources += _consumer.get_amount()
					_did_consume = true
			
			if _did_consume:
				_parched_tiles.append(_tile)
			
			if _net_resources >= 0:
				return _parched_tiles
	
	return _parched_tiles

func _parse_network(current : Tile, distance : int) -> void:
	for tile in current.get_connections():
		if not tile is Tile:
			continue
		if tile.distance <= distance:
			continue
		tile.distance = min(tile.distance, distance)
		tile.connected = true
		_parse_network(tile, distance + 1)

func get_connected_root_tiles() -> Array:
	var connected_tiles = []
	for tile in tiles.values():
		if is_instance_valid(tile) == false || tile.is_queued_for_deletion():
			continue
			
		if tile.connected:
			connected_tiles.append(tile)
			
	return connected_tiles

func on_spawn_plant(fertile_soil: Entity, pos : Vector2) -> void:
	var new_plant = plant_scene.instance() as Plant
	new_plant.position = pos
	var cellv = _terrain.world_to_map(pos)
	new_plant.cellv = cellv
	new_plant.head_tile_cellv = cellv
	new_plant.head_tile_cellv.y += 1
	new_plant.fertile_soil = fertile_soil
	_plants[cellv] = new_plant
	add_child(new_plant)
	_update_plant(new_plant)
	
	Events.emit_signal("num_plants_changed", get_plants_count())

# using cellv instead of 'Plant' to avoid dealing with invalid instances
func plant_dead(cellv : Vector2) -> void:
	if _plants.has(cellv):
		_plants.erase(cellv)
		Events.emit_signal("num_plants_changed", get_plants_count())

func get_network_head(_p : Plant) -> Tile:
	return get_tile_at_position(_p.head_tile_cellv)	

func get_connected_root_tiles_by_distance(_distance : int) -> Array:
	var _tiles : Array = []
	for _t in get_connected_root_tiles():
		if _t is Tile:
			var _tile : Tile = _t as Tile
			if _tile.distance == _distance:
				_tiles.append(_tile)
	return _tiles

func sort_distance_ascending(a, b) -> bool:
	return a.get_distance() < b.get_distance()
	
func sort_distance_descending(a , b) -> bool:
	return a.get_distance() > b.get_distance()

func get_tiles_sorted_by_distance() -> Array:
	var _tiles = get_connected_root_tiles()
	_tiles.sort_custom(self, "sort_distance_descending")
	return _tiles
	
func get_longest_distance() -> int:
	var _longest_distance = 0
	for _t in get_connected_root_tiles():
		if _t is Tile:
			var _tile : Tile = _t as Tile
			_longest_distance = max(_longest_distance, _tile.distance)
			
	return _longest_distance

func get_plants_count() -> int:
	return _plants.size()

func on_resource_consumption_changed(_dictionary : Dictionary):
	_update_parche_preview()
