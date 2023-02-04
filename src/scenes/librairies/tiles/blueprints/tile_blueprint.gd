extends TileBlueprintBase
class_name TileBlueprint

export (int) var tile_index

onready var resource_manager : ResourceManager = $ResourceManager
onready var _connections :Area2D= $skin/Connections

onready var _connection_n :CollisionShape2D= $skin/Connections/CollisionShape2D_N
onready var _connection_e :CollisionShape2D= $skin/Connections/CollisionShape2D_E
onready var _connection_s :CollisionShape2D= $skin/Connections/CollisionShape2D_S
onready var _connection_w :CollisionShape2D= $skin/Connections/CollisionShape2D_W

var can_rotate : bool = true
var real_rotation : float = 0.0
var valid : bool setget set_is_valid,get_is_valid


func _ready() -> void:
	tile_scene = Resources.Tiles[tile_index]
	match tile_index:
		Resources.TILES.STRAIGHT:
			$skin/Sprite_Straight.visible = true
			_connection_n.disabled = true
			_connection_s.disabled = true
		Resources.TILES.ELBOW:
			$skin/Sprite_Elbow.visible = true
			_connection_e.disabled = true
			_connection_s.disabled = true
		Resources.TILES.THREEWAY:
			$skin/Sprite_ThreeWay.visible = true
			_connection_e.disabled = true
		Resources.TILES.FOURWAY:
			$skin/Sprite_FourWay.visible = true
			can_rotate = false
	
	load_resource_cost()

func can_afford() -> bool:
	return Globals.player_resource_manager.get_resource_manager().can_consume_all(resource_manager)

func try_consume() -> bool:
	if can_afford() == false:
		return false
	
	return Globals.player_resource_manager.get_resource_manager().try_consume_all(resource_manager)

func load_resource_cost():
	var _resource_cost = Resources.Tiles_resource_cost[tile_index]
	if resource_manager:
		for _rc in _resource_cost:
			var _cost = _resource_cost[_rc]
			resource_manager.add_new_resource(_rc, _cost)

func rotate_blueprint(cw : bool) -> void:
	if not can_rotate:
		return
	var rot = 90.0 if cw else -90.0
	real_rotation = wrapf(real_rotation + rot, 0.0, 360.0) 
	$skin.rotation_degrees = real_rotation


func set_is_valid(value : bool) -> void:
	valid = value
	$Sprite_Invalid.visible = not valid
	$ResourceManager.visible = valid


func get_is_valid() -> bool:
	return valid
	

func is_connected_to_network(except: Tile) -> bool:
	for area in _connections.get_overlapping_areas():
		var a_owner = area.owner
		if a_owner == except:
			continue
		if a_owner is Plant:
			return true
		if a_owner is Tile and a_owner.connected:
			return true
	return false
