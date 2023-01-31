extends Node2D

export var resources = []

func _ready():
	for _c in get_children():
		var rsc :ResourceNode= _c as ResourceNode
		if is_instance_valid(rsc):
			resources.append(rsc)

func get_resource(identifier:String) -> ResourceNode:
	for r in resources:
		if r.identifier == identifier:
			return r
	
	return null
