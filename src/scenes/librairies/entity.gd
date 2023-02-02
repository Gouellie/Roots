extends Node2D
class_name Entity
# entity represents any object that can be selected 

export (Array, int) var resolve_steps = []

var cellv : Vector2
var step_resolver : StepResolver = StepResolver.new()

func _ready():
	_init_step_resolver()

func _init_step_resolver():
	step_resolver.resolve_steps = resolve_steps
	step_resolver.connect("resolved", self, "_on_step_resolved")
	add_child(step_resolver)

func _on_step_resolved(_step):
	print(String(_step) + " was resolved on entity base")
