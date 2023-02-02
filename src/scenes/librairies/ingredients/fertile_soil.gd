extends Ingredient


func _ready() -> void:
	$Button.visible = false


func _on_Area2D_area_entered(area: Area2D) -> void:
	$Button.visible = true


func _on_Area2D_area_exited(area: Area2D) -> void:
	$Button.visible = false


func _on_Button_pressed() -> void:
	Events.emit_signal("spawn_plant", position)
	queue_free()
