tool
extends Control

onready var texture_rect : TextureRect = $VBoxContainer/TextureControl/TextureRect
onready var amount_label : Label = $VBoxContainer/Control/Panel/Amount

var resource_node : ResourceNode = null setget set_resource_node 
#var update_frequency : float = 1.0
#var update_timer : float = 0.0
var display_string : String = "%s/%s"

func _init():
	Events.connect("main_scene_loaded", self, "on_main_scene_loaded")
	Events.connect("consumption_amount_changed", self, "on_consumption_amount_changed")

func on_main_scene_loaded() -> void:
	_update_values()


func set_resource_node(_resource_node:ResourceNode):
	resource_node = _resource_node
	resource_node.initialize()

	# assign icon & color accent based on the identifier
	if texture_rect:
		var _icon = Resources.icons[resource_node.identifier] as Texture
		if _icon:
			texture_rect.texture = _icon

func _update_values():
#	update_timer = 0
	if resource_node:
		if resource_node.identifier == Resources.SUNLIGHT:
			amount_label.text = String(resource_node.value)
		else:
			var _prod_amount = Globals.player_resource_manager.get_production_amount_by_resource(resource_node.identifier)
			var _cons_amount = Globals.player_resource_manager.get_consumption_amount_by_resource(resource_node.identifier)
			amount_label.text = display_string % [_cons_amount, _prod_amount]
			
			if _cons_amount > _prod_amount:
				$VBoxContainer/Control/Panel/Amount.add_color_override("font_color", Color.red)
			else:
				$VBoxContainer/Control/Panel/Amount.add_color_override("font_color", Color.white)


func _on_TextureRect_mouse_entered() -> void:
	var _prod_amount = Globals.player_resource_manager.get_production_amount_by_resource(resource_node.identifier)	
	var _cons_amount = Globals.player_resource_manager.get_consumption_amount_by_resource(resource_node.identifier)

	var resource_info = Resources.resource_info[resource_node.identifier]
	var info = Info.new(resource_info["name"])
	
	for _d in resource_info["details"]:
		info.add_info(_d)

	info.add_info(resource_info["prod"] % _prod_amount, 1)
	if resource_node.identifier != Resources.SUNLIGHT:
		info.add_info(resource_info["cons"] % _cons_amount, 1)

	Events.emit_signal("info_request", info)


func on_consumption_amount_changed(_dictionary : Dictionary):
	_update_values()
