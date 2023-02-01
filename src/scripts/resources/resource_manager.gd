extends Node2D
class_name ResourceManager

export var resource_types : Dictionary = {}

onready var resource_container  : ResourceContainer = $ResourceContainer

func _ready():
	for _rt in resource_types:
		var _value = resource_types[_rt]
		var _instance = resource_container.add_new_resource(_rt, _value)
			
	pass

func can_consume_all(_target_to_consume : ResourceManager) -> bool:
	for _identifier in _target_to_consume.get_all_resources():
		var _value = _target_to_consume.get_all_resources()[_identifier]
		if self.can_consume(_identifier, _value) == false:
			return false

	return true

func can_consume(identifier:String, amount:int) -> bool:
	var _resource_node : ResourceNode = resource_container.get_all_resources()[identifier]
	if is_instance_valid(_resource_node) == false:
		return false
	
	return _resource_node.value >= amount

func try_consume_all(_target_to_consume : ResourceManager) -> bool:
	if self.can_consume_all(_target_to_consume) == false:
		return false
	
	for _identifier in _target_to_consume.get_all_resources():
		var _value = _target_to_consume.get_all_resources()[_identifier]
		var result : bool = self.try_consume(_identifier, _value)
		if result == false:
			# This should never trigger
			Log.log_error(0, "Failed to consume " + _identifier + " on a ResourceManager. Exiting.")
			return false

	return true

func try_consume(_identifier : String, _amount : int) -> bool:
	var _consumable = can_consume(_identifier, _amount)
	if _consumable == false:
		return false
	
	var _resource_node : ResourceNode = resource_container.get_all_resources()[_identifier]
	_resource_node.deduct_resource(_amount)
	return true
