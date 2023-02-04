extends Node2D
class_name Entity
# entity represents any object that can be selected 

export var fog_reveal_radius : int = 0
var has_mouse : bool
var cellv : Vector2
var step_resolver : StepResolver = StepResolver.new()

func _ready():
	step_resolver.ready(self)
