extends Node2D
class_name PlayerResourceManager

onready var resource_manager = $ResourceManager setget , get_resource_manager

func get_resource_manager() -> ResourceManager:
	return resource_manager as ResourceManager

func _ready():
	Events.emit_signal("init_player_resource_manager", self)

func get_consumption_amount_by_resource(identifier : String) -> int:
	var _d : Dictionary = get_consumption_amount()
	if _d.has(identifier):
		return _d[identifier]
	return 0
	
func get_consumption_amount() -> Dictionary:
	var _d : Dictionary = {}
	var _resolvers = Globals.turn_manager.step_resolvers as Dictionary
	if _resolvers == null:
		return _d
	
	if _resolvers.has(Turns.STEP_ORDER.resources_consume):
		var _consumers = _resolvers[Turns.STEP_ORDER.resources_consume]
		for _c in _consumers:
			if is_instance_valid(_c) == false || _c.is_queued_for_deletion():
				continue
			
			var _c_resolver : StepResolver = _c as StepResolver
			if _c_resolver == null:
				continue
			
			for _rb in _c_resolver.resolve_behavior:
				if _rb is ConsumerResolveBehavior:
					var _c_behav = _rb as ConsumerResolveBehavior
					if _d.has(_c_behav.identifier):
						_d[_c_behav.identifier] += _c_behav.amount
					else:
						_d[_c_behav.identifier] = _c_behav.amount
		
	return _d

func get_production_amount_by_resource(identifier : String) -> int:
	var _d : Dictionary = get_production_amount()
	if _d.has(identifier):
		return _d[identifier]
	return 0
		
func get_production_amount() -> Dictionary:
	var _d : Dictionary = {}
	var _resolvers = Globals.turn_manager.step_resolvers as Dictionary
	if _resolvers == null:
		return _d
	
	if _resolvers.has(Turns.STEP_ORDER.resources_produce):
		var _consumers = _resolvers[Turns.STEP_ORDER.resources_produce]
		for _c in _consumers:
			if is_instance_valid(_c) == false || _c.is_queued_for_deletion():
				continue
			
			var _c_resolver : StepResolver = _c as StepResolver
			if _c_resolver == null:
				continue
			for _rb in _c_resolver.resolve_behavior:
				if _rb is ProducerResolveBehavior:
					var _c_behav = _rb as ProducerResolveBehavior
					if _d.has(_c_behav.identifier):
						_d[_c_behav.identifier] += _c_behav.get_amount()
					else:
						_d[_c_behav.identifier] = _c_behav.get_amount()
			
	return _d
