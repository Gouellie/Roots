extends Node2D
class_name ResourceManager

# warning-ignore:unused_signal
signal new_resource_added(resource_node)

signal resource_amount_added(indentifier, amount)
signal resource_amount_deducted(indentifier, amount)

export (Dictionary)var resource_types : Dictionary = {}

var resource_container : ResourceContainer

func _init():
	# load pre-constructed ResourceContainer, if it's present
	for _c in get_children():
		if _c is ResourceContainer:
			resource_container = _c as ResourceContainer
			return

func _ready():
	# construct ResourceContainer if none was found
	if resource_container == null:
		resource_container = ResourceContainer.new()
		resource_container.name = "ResourceContainer_Instance"
		add_child(resource_container)

	for _rt in resource_types:
		var _value = resource_types[_rt]
		var _instance = add_new_resource(_rt, _value)
		
func can_consume_all(_target_to_consume : ResourceManager) -> bool:
	for _identifier in _target_to_consume.get_all_resources():
		var _value = _target_to_consume.get_all_resources()[_identifier]
		if self.can_consume(_identifier, _value.value) == false:
			return false

	return true

func can_consume(identifier:String, amount:int) -> bool:
	var _resource_node : ResourceNode = get_resource(identifier)
	if is_instance_valid(_resource_node) == false:
		return false
	
	return _resource_node.value >= amount

func try_consume_all(_target_to_consume : ResourceManager) -> bool:
	if self.can_consume_all(_target_to_consume) == false:
		return false
	
	for _identifier in _target_to_consume.get_all_resources():
		var _value = _target_to_consume.get_all_resources()[_identifier]
		var result : bool = self.try_consume(_identifier, _value.value)
		if result == false:
			# This should never trigger
			Log.log_error(0, "Failed to consume " + _identifier + " on a ResourceManager. Exiting.")
			return false

	return true

func try_consume(_identifier : String, _amount : int) -> bool:
	var _consumable = can_consume(_identifier, _amount)
	if _consumable == false:
		return false
	var _resource_node : ResourceNode = get_resource(_identifier)
	_resource_node.deduct_resource(_amount)
	emit_signal("resource_amount_deducted", _identifier, _amount)
	return true

func get_all_resources() -> Dictionary:
	var _d = {}
	for _r in  resource_container.resources:
		var _rsc : ResourceNode = _r as ResourceNode
		if is_instance_valid(_rsc):
			_d[_rsc.identifier] = _rsc
		
	return _d

func get_resource(identifier:String) -> ResourceNode:
	for r in resource_container.resources:
		if r.identifier == identifier:
			return r
	
	return null

func add_new_resource(_identifier:String, _defaultAmount:int) -> ResourceNode:
	for _r in resource_container.resources:
		var _rsc : ResourceNode = _r as ResourceNode
		if is_instance_valid(_rsc) && _rsc.identifier == _identifier:
			return _rsc
	
	var _instance : ResourceNode = ResourceNode.new()
	resource_container.resources.append(_instance)
	resource_container.add_child(_instance)
	_instance.name = "ResourceNode_" + _identifier
	_instance.identifier = _identifier
	_instance.value = _defaultAmount
	self.emit_signal("new_resource_added", _instance)
	return _instance

func add_to_resource(_identifier:String, _amount:int) -> void:
	var rsc = get_resource(_identifier)
	if is_instance_valid(rsc) == false:
		return
	rsc.add_resource(_amount)
	emit_signal("resource_amount_added", _identifier, _amount)

func deduct_from_resource(_identifier:String, _amount:int) -> void:
	var rsc = get_resource(_identifier)
	if is_instance_valid(rsc) == false:
		return
	rsc.deduct_resource(_amount)
	emit_signal("resource_amount_deducted", _identifier, _amount)

func initialize_gui():
	for _c in resource_container.get_children():
		var rsc : ResourceNode = _c as ResourceNode
		if is_instance_valid(rsc):
			rsc.initialize()
