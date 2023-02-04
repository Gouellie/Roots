extends Entity
class_name Ingredient

export (bool) var is_blocking_tiles := false
var fog_revealed : bool = false setget set_fog_revealed
export var reveal_upon_unfog : bool = true
export var sprite_node_path : NodePath

export (String) var ingredient_name
export (PoolStringArray) var additional_information

var sprite : Sprite

func _ready():
	set_fog_revealed(fog_revealed)

	
func _on_unfogged():
	Events.emit_signal("ingredient_unfogged", self)


func set_fog_revealed(value : bool):
	fog_revealed = value
	if reveal_upon_unfog:
		sprite = get_node(sprite_node_path) as Sprite
		sprite.visible = value
		
		if value:
			_on_unfogged()


func get_modifier()-> void:
	pass


func _on_MouseDetector_mouse_entered() -> void:
	has_mouse = true


func _on_MouseDetector_mouse_exited() -> void:
	has_mouse = false

	
func _input(event: InputEvent) -> void:
	if not has_mouse:
		return
	var info = Info.new(ingredient_name)
	var current :int= 0
	for _add_info in additional_information:
		info.add_info(_add_info, current)
		current += 1
	Events.emit_signal("info_request", info)

