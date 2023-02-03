extends Control
class_name ResourceCostStackPanel

var resource_cost_scene = load("res://src/ui/resource_cost.tscn")
onready var resource_manager
onready var resource_container : HBoxContainer = $HBoxContainer

var containers = []

func _ready():
	for _c in resource_container.get_children():
		_c.queue_free()
		
	resource_manager = get_parent() as ResourceManager
	if resource_manager:
		resource_manager.connect("new_resource_added", self, "on_new_resource_added")

func on_new_resource_added(_resource_node : ResourceNode):
	for _c in containers:
		if _c.identifier == _resource_node.identifier:
			return
	
	if resource_cost_scene:
		var _instance = resource_cost_scene.instance()
		_instance.resource_node = _resource_node
		resource_container.add_child(_instance)
		containers.append(_instance)
		
