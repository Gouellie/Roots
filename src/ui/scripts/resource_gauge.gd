tool
extends Control

var resource_node : ResourceNode = null setget set_resource_node 

onready var texture_rect : TextureRect = $Margin/VBoxContainer/CenterContainer/TextureRect
onready var texture_progress : TextureProgress = $Margin/VBoxContainer/CenterContainer/Gauge
onready var amount_label : Label = $Margin/VBoxContainer/Amount

func set_resource_node(_resource_node:ResourceNode):
	resource_node = _resource_node
	resource_node.connect("node_update", self, "on_node_updated")
	resource_node.initialize()

	# assign icon & color accent based on the identifier
	if texture_rect:
		var _icon = Resources.icons[resource_node.identifier] as Texture
		if _icon:
			texture_rect.texture = _icon

	if texture_progress:
		var _color = Resources.resource_color[resource_node.identifier] as Color
		if _color:
			texture_progress.tint_progress = _color

func on_node_updated():
	if resource_node:
		amount_label.text = String(resource_node.value)
		texture_progress.min_value = resource_node.min_value
		texture_progress.max_value = resource_node.max_value
		texture_progress.value = resource_node.value
