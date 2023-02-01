extends Node2D
class_name ResourceManager

export var resource_types : Dictionary = {}

onready var resource_container  : ResourceContainer = $ResourceContainer

func _ready():
	for _rt in resource_types:
		var _value = resource_types[_rt]
		var _instance = resource_container.add_new_resource(_rt, _value)
			
	pass

func can_consume(identifier:String, amount:int) -> bool:
	var _resource_node : ResourceNode = resource_container.get_all_resources()[identifier]
	if is_instance_valid(_resource_node) == false:
		return false
	
	return _resource_node.value >= amount

func try_consume(identifier:String, amount:int) -> bool:
	var _consumable = can_consume(identifier, amount)
	if _consumable == false:
		return false
	
	var _resource_node : ResourceNode = resource_container.get_all_resources()[identifier]
	_resource_node.deduct_resource(amount)
	return true
