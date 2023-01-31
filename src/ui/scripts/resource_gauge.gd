tool
extends Control

export var identifier : String
export var icon : Texture
export var color_progress : Color

onready var texture_rect : TextureRect = $Margin/VBoxContainer/CenterContainer/TextureRect
onready var texture_progress : TextureProgress = $Margin/VBoxContainer/CenterContainer/Gauge
onready var amount_label : Label = $Margin/VBoxContainer/Amount

func _ready():
	if texture_rect:
		texture_rect.texture = icon

	if texture_progress:
		texture_progress.tint_progress = color_progress

	Events.connect("resource_node_updated", self, "on_resource_node_updated")

func on_resource_node_updated(_identifier, _node) -> void:
	if is_instance_valid(amount_label) == false || identifier != _identifier:
		return
		
	var _rsc = _node as ResourceNode
	if _rsc:
		amount_label.text = String(_rsc.value)
		texture_progress.min_value = _rsc.min_value
		texture_progress.max_value = _rsc.max_value
		texture_progress.value = _rsc.value

