extends Control
class_name ResourceControl

export (String)var identifier : String = "sunlight"

var resource_node : ResourceNode setget set_resource_node, get_resource_node


func _ready():
	for _sibling in get_parent().get_children():
		var _rm : ResourceManager = _sibling as ResourceManager
		if is_instance_valid(_rm):
			_rm.connect("new_resource_added", self, "on_new_resource_added")
			break
	Events.connect("player_resource_amount_added", self, "on_player_amount_added")
	Events.connect("player_resource_amount_deducted", self, "on_player_amount_deducted")

	
func on_new_resource_added(_resource_node : ResourceNode):
	if _resource_node.identifier == identifier:
		set_resource_node(_resource_node)
	
func set_resource_node(_resource_node : ResourceNode):
	resource_node = _resource_node
	resource_node.connect("node_update", self, "on_node_updated")
	_execute_update()

func get_resource_node() -> ResourceNode:
	return resource_node

func _execute_update():
	if resource_node:
		identifier = resource_node.identifier
		name = "resource_cost_control_" + identifier

		var _texture = get_node("Container/Icon")
		if _texture:
			_texture.texture = Resources.icons[resource_node.identifier]

		var _label = get_node("Container/Count")
		if _label:
			_label.text = "x" + String(resource_node.get_value())

func on_node_updated():
	_execute_update()


func on_player_amount_added(_identifier, _amount) -> void:
	if identifier != _identifier:
		return
	check_if_can_afford()


func on_player_amount_deducted(_identifier, _amount) -> void:
	if identifier != _identifier:
		return
	check_if_can_afford()


func check_if_can_afford() -> void:
	var can_afford = Globals.player_resource_manager.get_resource_manager().can_consume(identifier, resource_node.get_value()) 
	var _invalid_icon = get_node("Control/Icon_Invalid")
	_invalid_icon.visible = not can_afford
