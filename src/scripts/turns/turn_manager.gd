extends Node2D
class_name TurnManager

var turn : int = 1
var step : int = 1

export (int)var max_turns : int = 30

var step_resolvers = {}

func _ready():
	Turns.emit_signal("turn_manager_initialized", self)
	Turns.connect("request_turn_end", self, "on_turn_end_requested")
	Turns.connect("request_resolve", self, "on_request_resolve")

func on_turn_end_requested(_sender):
	next_step()
#	end_turn()

func on_request_resolve(_sender, _step):
	var _resolver : StepResolver = _sender as StepResolver
	if _resolver == null:
		return
	
	if step_resolvers.has(_step):
		var _arr = step_resolvers[_step] as Array
		if _arr:
			_arr.append(_resolver)
	else:
		step_resolvers[_step] = [_resolver]

func resolve_requests():
	var _has_key : bool = step_resolvers.has(step)
	if _has_key == false:
		return
	
	var _resolvers = step_resolvers[step] as Array
	if _resolvers == null:
		return
	
	for _r in _resolvers:
		if is_instance_valid(_r) == false || _r.is_queued_for_deletion():
			_resolvers.remove(_resolvers.find(_r, 0))
			continue
		
		var _step_resolver = _r as StepResolver
		if _step_resolver:
			_step_resolver.execute_resolve(step)

func next_step():
	step += 1
	var _has_key : bool = Turns.step_order.has(step)
	if _has_key == false:
		end_turn()
		return
	
	var _signal = Turns.step_order[step]
	resolve_requests()
	Turns.emit_signal("step_next", step)
	Turns.emit_signal(_signal)

func end_turn():
	turn += 1
	if turn > max_turns:
		end_session()
		return
	
	Turns.emit_signal("turn_next", turn)
	step = 0
	next_step()

func end_session():
	pass
