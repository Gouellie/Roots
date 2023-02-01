extends Node
class_name StepResolver

signal resolved(step)
export (Array) var resolve_steps : Array = []

func _ready():
	for _step in resolve_steps:
		var _i = _step as int
		if _i:
			file_resolve_request(_i)

func file_resolve_request(_step:int):
	Turns.emit_signal("request_resolve", self, _step)
	
func execute_resolve(_step):
	emit_signal("resolved", _step)
