extends Node2D
class_name ResourceContainer

export var resources = []
export var resources : = []

func _ready():
	for _c in get_children():
		var rsc :ResourceNode= _c as ResourceNode
		var rsc : ResourceNode = _c as ResourceNode
		if is_instance_valid(rsc):
			resources.append(rsc)

func get_resource(identifier:String) -> ResourceNode:
	for r in resources:
		if r.identifier == identifier:
			return r
	
	return null
=======

func add_resource(identifier:String, amount:int) -> void:
	var rsc = get_resource(identifier)
	if is_instance_valid(rsc) == false:
		return
	
	rsc.add_resource(amount)

func deduct_resource(identifier:String, amount:int) -> void:
	var rsc = get_resource(identifier)
	if is_instance_valid(rsc) == false:
		return
	
	rsc.decuct_resource(amount)

func initialize_gui():
	for _c in get_children():
		var rsc : ResourceNode = _c as ResourceNode
		if is_instance_valid(rsc):
			rsc.initialize()
	pass
