tool
extends Control

onready var texture_rect : TextureRect = $Margin/VBoxContainer/CenterContainer/TextureRect
onready var amount_label : Label = $Amount

var resource_node : ResourceNode = null setget set_resource_node 
var update_frequency : float = 1.0
var update_timer : float = 0.0
var display_string : String = "%s+%s/-%s"

func _ready():
	Events.connect("tile_placed", self, "on_tile_placed")

func set_resource_node(_resource_node:ResourceNode):
	resource_node = _resource_node
	resource_node.connect("node_update", self, "on_node_updated")
	resource_node.initialize()

	# assign icon & color accent based on the identifier
	if texture_rect:
		var _icon = Resources.icons[resource_node.identifier] as Texture
		if _icon:
			texture_rect.texture = _icon

func on_tile_placed(_tile):
	_update_values()
	
func on_node_updated():
	_update_values()

func _process(_delta):
	update_timer += _delta
	if update_timer >= update_frequency:
		update_timer = 0
		_update_values()

#var display_string : String = "{current}/+{increase}/-{decrease}"
func _update_values():
	update_timer = 0
	if resource_node:
		var _current_value = String(resource_node.value)
		var _prod_amount = String(Globals.player_resource_manager.get_production_amount_by_resource(resource_node.identifier))
		var _cons_amount = String(Globals.player_resource_manager.get_consumption_amount_by_resource(resource_node.identifier))
		amount_label.text = display_string % [_current_value, _prod_amount, _cons_amount]
