extends Ingredient


var _root_tile : Tile


func _ready() -> void:
	$Button.visible = false


func _process(delta: float) -> void:
	if is_instance_valid(_root_tile):
		$Button.visible = _root_tile.connected


func _on_Area2D_area_entered(area: Area2D) -> void:
	$Button.visible = true
	_root_tile = area.owner as Tile


func _on_Area2D_area_exited(area: Area2D) -> void:
	$Button.visible = false
	_root_tile = area.owner	as Tile


func _on_Button_pressed() -> void:
	if _root_tile == null:
		return
	if not _root_tile.connected:
		return 
	Events.emit_signal("spawn_plant", position)
	queue_free()
