extends Node2D
class_name EntityManager

export (NodePath) var terrain_node_path
export (NodePath) var plant_master_node_path

const _eraser_scene := preload("res://src/scenes/librairies/tiles/blueprints/tile_eraser.tscn")

var tiles := {}

var _blueprint : TileBlueprint

var _eraser : TileBlueprintEraser
var _placeable_blueprint : bool
var _eraser_mode : bool

onready var _plant_master : Plant
onready var _terrain : TileMap
onready var tile_offset : Vector2


func _ready() -> void:
	_plant_master = get_node(plant_master_node_path) as Plant
	_terrain = get_node(terrain_node_path) as TileMap
	tile_offset = _terrain.cell_size / 2
	Events.connect("tilepanel_selected", self, "on_tile_selected")
	Events.connect("eraser_mode_toggled", self, "on_eraser_mode_toggled")


func _process(_delta: float) -> void:
	_move_blueprint(get_global_mouse_position())


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


func on_eraser_mode_toggled()-> void:
	_set_eraser_mode(not _eraser_mode)


func _set_eraser_mode(value : bool) -> void:
	if _eraser_mode == value:
		return
	_eraser_mode = value
	if _eraser_mode:
		_eraser = _eraser_scene.instance() as TileBlueprintBase
		add_child(_eraser)
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
	if event.is_action_pressed("ui_cancel"):
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
	var head = _plant_master._get_network_head()
	# no head connected to flower means no good
	if not is_instance_valid(head):
		return
	if head.is_queued_for_deletion():
		return
	head.connected = true
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

