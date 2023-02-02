extends Entity
class_name Tile

var resource_manager : ResourceManager
var health_node : ResourceNode
var real_rotation : float = 0.0
var connected : bool = true setget set_is_connected,get_is_connected
var distance : int setget set_distance,get_distance
var is_leaf_node : bool

onready var rig := $Rig
onready var _leaf := $Leaf
onready var _connections :Area2D= $Rig/Connections
onready var _ingredient_detector :Area2D= $IngredientDetector

func _init():
	resource_manager = ResourceManager.new()
	resource_manager.name = "Health_ResourceManager"
	add_child(resource_manager)

func _ready() -> void:
	rig.rotation_degrees = real_rotation
	if resource_manager:
		health_node = resource_manager.add_new_resource(Resources.HEALTH, Globals.TILE_HEALTH)
		health_node.connect("node_depleted", self, "on_health_depleted")
		health_node.connect("node_update", self, "on_health_changed")
		$Health.text = String(health_node.value)

func on_health_depleted():
	self.queue_free()
	pass

func on_health_changed():
	# do something to update visual here later
	$Health.text = String(health_node.value)
	pass
	$Rig/Parched.visible = true
	

func apply_damage(_damage : int):
	resource_manager.deduct_from_resource(Resources.HEALTH, _damage)


func set_is_connected(value : bool) -> void:
	connected = value
	$Rig/Disconnected.visible = not connected
	$Distance.visible = connected

func get_is_connected() -> bool:
	return connected

func get_connections() -> Directory:
	var connections = []
	for area in _connections.get_overlapping_areas():
		if area.owner is Entity:
			connections.append(area.owner)
	is_leaf_node = connections.size() < 2
	_leaf.visible = is_leaf_node
	return connections

func get_overlapping_ingredient() -> Ingredient:
	return Globals.ingredient_manager.get_ingredient_at(cellv)

func set_distance(value : int) -> void:
	distance = value
	$Distance.text = str(distance)

func get_distance() -> int:
	return distance
