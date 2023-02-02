extends Entity
class_name Tile

var real_rotation : float = 0.0
var connected : bool = true setget set_is_connected,get_is_connected
var distance : int setget set_distance,get_distance
var is_leaf_node : bool


onready var rig := $Rig
onready var _leaf := $Leaf
onready var _connections :Area2D= $Rig/Connections


func _ready() -> void:
	rig.rotation_degrees = real_rotation


func set_is_connected(value : bool) -> void:
	connected = value
	$Disconnected.visible = not connected
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


func set_distance(value : int) -> void:
	distance = value
	$Distance.text = str(distance)


func get_distance() -> int:
	return distance
