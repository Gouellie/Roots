extends Ingredient


var _root_tile : Tile
var ferlitized : bool = false

onready var button := $Button
onready var sprite_attention := $Sprite_Attention
onready var resource_manager : ResourceManager = $ResourceManager

func _init():
	Events.connect("num_plants_changed", self, "on_num_plants_changed")

func _ready() -> void:
	button.visible = false
	sprite_attention.visible = true

func _process(delta: float) -> void:
	if ferlitized:
		return	
	if is_instance_valid(_root_tile):
		var show_button = _root_tile.connected
		_toggle_visibility(show_button,not show_button)		
	
func can_afford() -> bool:
	if resource_manager == null:
		return true

	return Globals.player_resource_manager.get_resource_manager().can_consume_all(resource_manager)

func try_consume_resources() -> bool:
	if resource_manager == null:
		return false

	return Globals.player_resource_manager.get_resource_manager().try_consume_all(resource_manager)
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	if ferlitized:
		return	
	_toggle_visibility(true,false)
	_root_tile = area.owner as Tile


func _on_Area2D_area_exited(area: Area2D) -> void:
	if ferlitized:
		return
	_toggle_visibility(false,true)
	_root_tile = area.owner	as Tile


func _on_Button_pressed() -> void:
	if _root_tile == null:
		return
	if not _root_tile.connected:
		return 
		
	if can_afford() == false:
		return
	
	if try_consume_resources() == false:
		# this should never trigger
		return
			
	Events.emit_signal("spawn_plant", position)
	ferlitized = true
	_toggle_visibility(false,false)


func _toggle_visibility(show_button, show_icon) -> void:
	button.visible = show_button
	sprite_attention.visible = show_icon
	
	for _c in get_children():
		if _c is ResourceControl:
			_c.visible = show_button

func on_num_plants_changed(_num_plants):
	if resource_manager as ResourceManager:
		var _rm : ResourceManager = resource_manager
		for _identifier in _rm.get_all_resources():
			_rm.get_resource(_identifier).set_value(_num_plants) 
