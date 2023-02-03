extends Node2D
class_name TurnManager

# warning-ignore:unused_signal
signal time_remaining_changed(_time_remaining)

export (int)var max_turns : int = 30

var turn : int = 1
var step : int = Turns.STEP_ORDER.placing
var step_resolvers = {}
var time_remaining : float = Turns.time_per_turn setget set_time_remaining, get_time_remaining

func _init():
	Events.emit_signal("init_turn_manager", self)

func set_time_remaining(_value : float):
	time_remaining = _value
	emit_signal("time_remaining_changed", _value)
	
func get_time_remaining() -> float:
	return time_remaining

func _process(delta):
	if step != Turns.STEP_ORDER.placing:
		return
	
	set_time_remaining(time_remaining - delta)
	
	if time_remaining <= 0:
		_start_end_turn_sequence()

func _ready():
	Turns.emit_signal("turn_manager_initialized", self)
	Turns.connect("request_turn_end", self, "on_turn_end_requested")
	Turns.connect("request_resolve", self, "on_request_resolve")
	
	start_turn()

func _start_end_turn_sequence():
	if step != Turns.STEP_ORDER.placing:
		return
	
	next_step()
	while step != Turns.STEP_ORDER.placing:
		next_step()

func on_turn_end_requested(_sender):
	_start_end_turn_sequence()

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

func start_turn():
	time_remaining = Turns.time_per_turn
	step = 0
	
	while step != Turns.STEP_ORDER.placing:
		next_step()
	
func end_turn():
	turn += 1
	if turn > max_turns:
		end_session()
		return
	
	Turns.emit_signal("turn_next", turn)
	start_turn()

func end_session():
	pass
