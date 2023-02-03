extends Node2D
class_name EntityManager

export (NodePath) var terrain_node_path
export (NodePath) var plant_master_node_path

const plant_scene := preload("res://src/scenes/librairies/plants/plant.tscn")

const _eraser_scene := preload("res://src/scenes/librairies/tiles/blueprints/tile_eraser.tscn")

var tiles := {}

var _blueprint : TileBlueprint

var _eraser : TileBlueprintEraser
var _placeable_blueprint : bool
var _eraser_mode : bool
var _plants := []


onready var _plant_master : Plant
onready var _terrain : TileMap
onready var tile_offset : Vector2

func _ready() -> void:
	_plant_master = get_node(plant_master_node_path) as Plant
	_terrain = get_node(terrain_node_path) as TileMap
	tile_offset = _terrain.cell_size / 2
	_register_ready_roots()
	Events.connect("tilepanel_selected", self, "on_tile_selected")
	Events.connect("eraser_mode_toggled", self, "on_eraser_mode_toggled")
	Events.connect("spawn_plant", self, "on_spawn_plant")
	Events.emit_signal("init_entity_manager", self)


func _process(_delta: float) -> void:
	_move_blueprint(get_global_mouse_position())


func _register_ready_roots() -> void:
	for tile in get_children():
		if tile is Tile:
			var cellv = _terrain.world_to_map(tile.position)
			tile.cellv = cellv
			tiles[cellv] = tile 


func _move_blueprint(mouse_position: Vector2) -> void:
	var cellv = _terrain.world_to_map(mouse_position)
	var snap_position = _terrain.map_to_world(cellv) + tile_offset
	if _eraser_mode and _eraser:
		_eraser.position = snap_position
	elif _blueprint:
		_blueprint.position = snap_position
		_blueprint.valid = _can_place_tile(cellv)


func on_tile_selected(sender : TilePanel, new_selected_blueprint : TileBlueprintBase)-> void:
	_clear_blueprint()
	if new_selected_blueprint:
		_set_eraser_mode(false)
		var new_blueprint = new_selected_blueprint.duplicate() as TileBlueprintBase
		new_blueprint.scale = Vector2(1.0,1.0)
		add_child(new_blueprint)
		_placeable_blueprint = true
		_blueprint = new_blueprint
	Events.emit_signal("building_mode_toggle", new_selected_blueprint != null)


func on_eraser_mode_toggled()-> void:
	_set_eraser_mode(not _eraser_mode)


func _set_eraser_mode(value : bool) -> void:
	if _eraser_mode == value:
		return
	_eraser_mode = value
	if _eraser_mode:
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
		elif _eraser_mode:
			_remove_tile()
		
	if _eraser_mode and event.is_action_pressed("ui_cancel"):
		_set_eraser_mode(false)


func _can_place_tile(cellv : Vector2) -> bool:
#	if is_cell_occupied(cellv):
#		return false
	if _terrain.get_cellv(cellv) == TileMap.INVALID_CELL:
		return false
	return _blueprint.is_connected_to_network(get_tile_at_position(cellv))


func _place_tile() -> void:
	if not _blueprint is TileBlueprint:
		return
	if not _blueprint.valid:
		return
	Events.emit_signal("building_mode_toggle", false)		
	var cellv = _terrain.world_to_map(_blueprint.position)
	remove_tile_at_position(cellv)

	var new_tile = _blueprint.tile_scene.instance() as Tile
	new_tile.position = _blueprint.position
	new_tile.real_rotation = _blueprint.real_rotation
	new_tile.cellv = cellv
	add_child(new_tile)
	tiles[cellv] = new_tile
	Events.emit_signal("tile_placed", new_tile)
	_clear_blueprint()
	# physics takes a few frame before it registers overlapping areas... 
	yield(get_tree().create_timer(0.1), "timeout")
	_update_network_connection()


func deplete_tile(_tile : Tile):
	remove_tile_at_position(_tile.cellv)
	if _tile.connected:
		_update_network_connection()


func _remove_tile() -> void:
	var cellv = _terrain.world_to_map(_eraser.position)
	if is_cell_occupied(cellv):
		if remove_tile_at_position(cellv):
			_update_network_connection()


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
	

func _update_plants() -> void:
	for _p in _plants:
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


func on_spawn_plant(pos : Vector2) -> void:
	var new_plant = plant_scene.instance() as Plant
	new_plant.position = pos
	new_plant.cellv = _terrain.world_to_map(pos)
	new_plant.head_tile_cellv = new_plant.cellv
	new_plant.head_tile_cellv.y += 1
	_plants.append(new_plant)
	add_child(new_plant)
	_update_plant(new_plant)


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

func sort_distance_ascending(a : Tile, b : Tile) -> bool:
	return a.distance < b.distance
	
func sort_distance_descending(a : Tile, b : Tile) -> bool:
	return a.distance > b.distance

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
	
func should_receive_damage(_tile : Tile) -> bool:
	var _sorted_tiles : Array = get_tiles_sorted_by_distance()
	var _node : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource("water")

	var _offset : int = int(min(_node.start + _node.delta, _node.value))
	if _offset < 0:
		return _sorted_tiles.find(_tile) < abs(_offset)
		
	return false
	

func get_plants_count() -> int:
	return _plants.size()
