extends Entity
class_name Tile

var real_rotation : float = 0.0
var connected : bool = true setget set_is_connected,get_is_connected

onready var rig := $Rig
onready var _connections :Area2D= $Rig/Connections


func _ready() -> void:
	rig.rotation_degrees = real_rotation


func set_is_connected(value : bool) -> void:
	connected = value
	$Disconnected.visible = not connected


func get_is_connected() -> bool:
	return connected


func get_connections() -> Directory:
	var connections = []
	for area in _connections.get_overlapping_areas():
		if area.owner is Entity:
			connections.append(area.owner)
	return connections
