extends Entity
class_name Tile

export var real_rotation : float = 0.0

var resource_manager : ResourceManager
var health_node : ResourceNode

var terrain_tile_cost : int

var connected : bool = true setget set_is_connected,get_is_connected
var queued_parche : bool = false setget set_queued_parche
var distance : int = 99 setget set_distance,get_distance
var is_leaf_node : bool

var building_mode_active : bool = false

var overlapping_ingredient : Ingredient setget set_overlapping_ingredient, get_overlapping_ingredient
onready var rig := $Rig
onready var _leaf := $Leaf
onready var _connections :Area2D= $Rig/Connections
onready var _ingredient_detector :Area2D= $IngredientDetector
onready var _sprite : Sprite = $Rig/Sprite

onready var connections_pos :PoolVector2Array = []
onready var connected_pos : PoolIntArray = []

var start_rect : Rect2

func _init():
	fog_reveal_radius = Globals.FOG_REVEAL_RADIUS_TILE
	resource_manager = ResourceManager.new()
	resource_manager.name = "ResourceManager"
	add_child(resource_manager)
	Events.connect("building_mode_toggle", self, "on_buidling_mode_toggle")

func _ready() -> void:
	start_rect = _sprite.region_rect
	rig.rotation_degrees = real_rotation
	if resource_manager:
		health_node = resource_manager.add_new_resource(Resources.HEALTH, Globals.TILE_HEALTH)
		health_node.connect("node_depleted", self, "on_health_depleted")
		health_node.connect("node_update", self, "on_health_changed")
			
	connections_pos = []
	for shape in _connections.get_children():
		if shape is CollisionShape2D:
			connections_pos.append(shape.position.rotated(rig.rotation))
			connected_pos.append(0)


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	if building_mode_active:
		var index = 0
		for pos in connections_pos:
			if connected_pos[index] == 0:
				draw_circle(pos, 10, Color.blue)
			index+=1


func on_health_depleted():
	Globals.entity_manager.deplete_tile(self)
	self.queue_free()

func update_sprite_region():
	var _pos : Vector2 = start_rect.position as Vector2
	var _size : Vector2 = start_rect.size as Vector2
	var _height = _size.y
	var _current_health = resource_manager.get_resource(Resources.HEALTH).value
	var _max_health = Globals.TILE_HEALTH
	var _percent : float =   float(_current_health) / float(_max_health)

	var _offset = 0
	if _percent <= .4:
		$Rig/Parched.visible = false
		$Rig/Disconnected.visible = queued_parche || not connected
		_offset = _height * 2
	elif _percent <= .7:
		$Rig/Parched.visible = queued_parche || not connected
		$Rig/Disconnected.visible = false
		_offset = _height * 1
	else:
		$Rig/Parched.visible = queued_parche || not connected
		$Rig/Disconnected.visible = false
		_offset = 0
	
	_sprite.set_region_rect(Rect2(Vector2(_pos.x, _pos.y - _offset), _size))
	$Rig/Parched.set_region_rect(Rect2(Vector2(_pos.x, _pos.y - _offset), _size))
	$Rig/Disconnected.set_region_rect(Rect2(Vector2(_pos.x, _pos.y - _offset), _size))

func set_queued_parche(_is_parched_preview : bool):
	queued_parche = _is_parched_preview
	update_sprite_region()
	

func on_health_changed():
	update_sprite_region()
	

func apply_damage(_damage : int):
	resource_manager.deduct_from_resource(Resources.HEALTH, _damage)


func set_is_connected(value : bool) -> void:
	connected = value
	$Rig/Disconnected.visible = not connected
	for _behavior in step_resolver.get_resolve_behavior():
		if _behavior is ResolveBehavior:
			var _b : ResolveBehavior = _behavior as ResolveBehavior
			_b.set_is_enabled(value)


func get_is_connected() -> bool:
	return connected


func get_connections() -> Directory:
	var connections = []
	for area in _connections.get_overlapping_areas():
		if area.owner is Entity:
			connections.append(area.owner)
	is_leaf_node = connections.size() < 2
#	_leaf.visible = is_leaf_node
	return connections

func set_overlapping_ingredient(_ingredient : Ingredient):
	overlapping_ingredient = _ingredient
	
func get_overlapping_ingredient() -> Ingredient:
	if overlapping_ingredient:
		return overlapping_ingredient
	
	set_overlapping_ingredient(Globals.ingredient_manager.get_ingredient_at(cellv))
	return overlapping_ingredient

func set_distance(value : int) -> void:
	distance = value
#	$Distance.text = str(distance)


func get_distance() -> int:
	return distance
	

func on_buidling_mode_toggle(is_active:bool) -> void:
	building_mode_active = is_active
	if not is_active:
		return


func _on_Connections_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	connected_pos[local_shape_index] = 1


func _on_Connections_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	connected_pos[local_shape_index] = 0
