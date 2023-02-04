extends Node2D

var step_resolver : StepResolver = StepResolver.new()
	
func _ready() -> void:
	step_resolver.ready(self)
	Events.emit_signal("main_scene_loaded")
