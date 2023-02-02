extends Node
class_name StepResolver

signal resolved(step)
export (Array, int) var resolve_steps = []

func _ready():
	for _step in resolve_steps:
		file_resolve_request(_step)

func file_resolve_request(_step:int):
	Turns.emit_signal("request_resolve", self, _step)
	
func execute_resolve(_step):
	emit_signal("resolved", _step)
