extends Node
class_name StepResolver

var owner_node2d : Node2D
var resolve_behavior : Array = []

func ready(_node : Node2D):
	owner_node2d = _node
	for _c in owner_node2d.get_children():
		var _behavior : ResolveBehavior =_c as ResolveBehavior
		if _behavior == null:
			continue
		
		resolve_behavior.append(_behavior)
		file_resolve_request(_behavior.resolve_step)
	
func file_resolve_request(_step:int):
	Turns.emit_signal("request_resolve", self, _step)
	
func execute_resolve(_step):
	for _b in resolve_behavior:
		if is_instance_valid(_b) == false || _b.is_queued_for_deletion():
			continue
			
		var _rb = _b as ResolveBehavior
		if _rb == null:
			continue
		if _rb.resolve_step == _step:
			_rb._execute_resolve_behavior()
