extends Node2D

var progress : float = 0 
var step_resolver : StepResolver = StepResolver.new()
	
func _ready() -> void:
	step_resolver.ready(self)


