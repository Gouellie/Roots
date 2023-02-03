extends Ingredient


var _root_tile : Tile
var ferlitized : bool = false

onready var button := $Button
onready var sprite_attention := $Sprite_Attention

func _ready() -> void:
	button.visible = false
	sprite_attention.visible = true


func _process(delta: float) -> void:
	if ferlitized:
		return	
	if is_instance_valid(_root_tile):
		var show_button = _root_tile.connected
		_toggle_visibility(show_button,not show_button)		
	

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
	Events.emit_signal("spawn_plant", position)
	ferlitized = true
	_toggle_visibility(false,false)


func _toggle_visibility(show_button, show_icon) -> void:
	button.visible = show_button
	sprite_attention.visible = show_icon
