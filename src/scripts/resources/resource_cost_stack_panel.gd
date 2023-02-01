extends Control
class_name ResourceCostStackPanel

var resource_cost_scene = load("res://src/ui/resource_cost.tscn")
onready var resource_manager
onready var resource_container : HBoxContainer = $HBoxContainer

func _ready():
	resource_manager = get_parent() as ResourceManager
	if resource_manager:
		resource_manager.connect("new_resource_added", self, "on_new_resource_added")
	
func on_new_resource_added(_resource_node : ResourceNode):
	if resource_cost_scene:
		var _instance = resource_cost_scene.instance()
		_instance.resource_node = _resource_node
		resource_container.add_child(_instance)
