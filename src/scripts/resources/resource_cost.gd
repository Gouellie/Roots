extends Control
class_name ResourceControl

var identifier : String

var resource_node : ResourceNode setget set_resource_node, get_resource_node

func set_resource_node(_resource_node : ResourceNode):
	resource_node = _resource_node
	resource_node.connect("node_update", self, "on_node_updated")
	_update_from_node()

func get_resource_node() -> ResourceNode:
	return resource_node

func _update_from_node():
	if resource_node:
		identifier = resource_node.identifier
		name = "resource_cost_control_" + identifier

		var _texture = get_node("Icon")
		if _texture:
			_texture.texture = Resources.icons[resource_node.identifier]

		var _label = get_node("Count")
		if _label:
			_label.text = "x" + String(resource_node.value)

func on_node_updated():
	_update_from_node()
