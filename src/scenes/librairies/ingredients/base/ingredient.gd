extends Entity
class_name Ingredient

export (bool) var is_blocking_tiles := false
var fog_revealed : bool = false setget set_fog_revealed
export var reveal_upon_unfog : bool = true
export var sprite_node_path : NodePath
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
