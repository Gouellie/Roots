extends Node2D
class_name ResourceContainer

var resources : Array = []

func get_all_resources() -> Dictionary:
	var _d = {}
	for _r in resources:
		var _rsc : ResourceNode = _r as ResourceNode
		if is_instance_valid(_rsc):
			_d.append({"Item": _rsc.identifier, "Stack":_rsc.value})
		
	return _d

func get_resource(identifier:String) -> ResourceNode:
	for r in resources:
		if r.identifier == identifier:
			return r
	
	return null

func add_new_resource(_identifier:String, _defaultAmount:int) -> ResourceNode:
	for _r in resources:
		var _rsc : ResourceNode = _r as ResourceNode
		if is_instance_valid(_rsc) && _rsc.identifier == _identifier:
			return _rsc

	var _instance = ResourceNode.new()
	resources.append(_instance)
	add_child(_instance)
	_instance.name = "ResourceNode_" + _identifier
	_instance.identifier = _identifier
	_instance.value = _defaultAmount
	return _instance

func add_to_resource(_identifier:String, _amount:int) -> void:
	var rsc = get_resource(_identifier)
	if is_instance_valid(rsc) == false:
		return
	
	rsc.add_resource(_amount)

func deduct_from_resource(_identifier:String, _amount:int) -> void:
	var rsc = get_resource(_identifier)
	if is_instance_valid(rsc) == false:
		return
	
	rsc.decuct_resource(_amount)

func initialize_gui():
	for _c in get_children():
		var rsc : ResourceNode = _c as ResourceNode
		if is_instance_valid(rsc):
			rsc.initialize()
	pass
