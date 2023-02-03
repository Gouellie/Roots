extends Node2D
class_name PlayerResourceManager


onready var resource_manager = $ResourceManager setget , get_resource_manager

var consumption_amount : Dictionary = {} setget ,get_consumption_amount
var production_amount : Dictionary = {} setget ,get_production_amount


func get_resource_manager() -> ResourceManager:
	return resource_manager as ResourceManager


func _init():
	Events.connect("tile_network_updated", self, "on_tile_network_updated")


func _ready():
	for _rsc in get_resource_manager().get_all_resources():
		var _node = get_resource_manager().get_all_resources()[_rsc] as ResourceNode
		if _node:
			_node.reset_on_next_turn = true
			_node.has_limits = false
			_node.value = _node.min_value
			
			if _node.identifier == Resources.SUNLIGHT:
				_node.reset_on_next_turn = false
	
	Events.emit_signal("init_player_resource_manager", self)


func get_consumption_amount() -> Dictionary:
	return consumption_amount
	
func get_consumption_amount_by_resource(identifier : String) -> int:
	var _d : Dictionary = get_consumption_amount()
	if _d.has(identifier):
		return _d[identifier]
	return 0
	

func get_production_amount() -> Dictionary:
	return production_amount
	
func get_production_amount_by_resource(identifier : String) -> int:
	var _d : Dictionary = get_production_amount()
	if _d.has(identifier):
		return _d[identifier]
	return 0


func _update_consumption_amount():
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
					var _c_behav : ConsumerResolveBehavior = _rb as ConsumerResolveBehavior
					if _c_behav.get_is_enabled() == false:
						continue
						
					if _d.has(_c_behav.identifier):
						_d[_c_behav.identifier] += _c_behav.amount
					else:
						_d[_c_behav.identifier] = _c_behav.amount
		
	consumption_amount =_d
	
func _update_production_amount():
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
					var _c_behav : ProducerResolveBehavior = _rb as ProducerResolveBehavior
					if _c_behav.get_is_enabled() == false:
						continue
						
					if _d.has(_c_behav.identifier):
						_d[_c_behav.identifier] += _c_behav.get_amount()
					else:
						_d[_c_behav.identifier] = _c_behav.get_amount()
			
	production_amount = _d

func on_tile_network_updated():
	_update_production_amount()
	_update_consumption_amount()
