extends Entity
class_name Tile

export var real_rotation : float = 0.0

var resource_manager : ResourceManager
var health_node : ResourceNode
var connected : bool = true setget set_is_connected,get_is_connected
var distance : int setget set_distance,get_distance
var is_leaf_node : bool

var building_mode_active : bool = false

onready var rig := $Rig
onready var _leaf := $Leaf
onready var _connections :Area2D= $Rig/Connections
onready var _ingredient_detector :Area2D= $IngredientDetector

onready var connections_pos :PoolVector2Array = []
onready var connected_pos : PoolIntArray = []

func _init():
	resource_manager = ResourceManager.new()
	resource_manager.name = "Health_ResourceManager"
	add_child(resource_manager)
	Events.connect("building_mode_toggle", self, "on_buidling_mode_toggle")


func _ready() -> void:
	rig.rotation_degrees = real_rotation
	if resource_manager:
		health_node = resource_manager.add_new_resource(Resources.HEALTH, Globals.TILE_HEALTH)
		health_node.connect("node_depleted", self, "on_health_depleted")
		health_node.connect("node_update", self, "on_health_changed")
		$Health.text = String(health_node.value)
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


func on_health_changed():
	$Health.text = String(health_node.value)
	$Rig/Parched.visible = true
	

func apply_damage(_damage : int):
	resource_manager.deduct_from_resource(Resources.HEALTH, _damage)


func set_is_connected(value : bool) -> void:
	connected = value
	$Rig/Disconnected.visible = not connected
#	$Distance.visible = connected

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

func get_overlapping_ingredient() -> Ingredient:
	return Globals.ingredient_manager.get_ingredient_at(cellv)

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
