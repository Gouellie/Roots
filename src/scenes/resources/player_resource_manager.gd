extends Node2D
class_name PlayerResourceManager


onready var resource_manager = $ResourceManager setget , get_resource_manager

var consumption_amount = {} setget set_consumption_amount, get_consumption_amount
var production_amount = {} setget set_production_amount, get_production_amount


func _init():
	Events.connect("tile_network_updated", self, "on_tile_network_updated")
	Turns.connect("turn_next", self, "on_turn_next")
	Events.connect("num_plants_changed", self, "on_num_plants_changed")
	Events.connect("shop_upgrade_level_changed", self, "on_shop_upgrade_level_changed")


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
	resource_manager.connect("resource_amount_added", self, "on_resource_amount_added")
	resource_manager.connect("resource_amount_deducted", self, "on_resource_amount_deducted")
	

func _refresh_income():
	_update_production_amount()
	_update_consumption_amount()
	Events.emit_signal("income_amount_changed")

func on_num_plants_changed(_num_plants):
	_refresh_income()


func on_shop_upgrade_level_changed():
	_refresh_income()

func on_turn_next(_turn):
	_refresh_income()


func on_tile_network_updated():
	_refresh_income()
	

func get_resource_manager() -> ResourceManager:
	return resource_manager as ResourceManager


func set_consumption_amount(_dictionary : Dictionary):
	consumption_amount = _dictionary
	Events.emit_signal("consumption_amount_changed", consumption_amount)


func get_consumption_amount() -> Dictionary:
	return consumption_amount


func get_consumption_amount_by_resource(identifier : String) -> int:
	var _d : Dictionary = get_consumption_amount()
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
			
			var _terrain_tile_cost = 0
			if is_instance_valid(_c_resolver.owner_node2d) && not _c_resolver.owner_node2d.is_queued_for_deletion():
				if _c_resolver.owner_node2d as Tile:
					var _t : Tile = _c_resolver.owner_node2d as Tile
					_terrain_tile_cost = _t.terrain_tile_cost
			
			for _rb in _c_resolver.resolve_behavior:
				if _rb is ConsumerResolveBehavior:
					var _c_behav : ConsumerResolveBehavior = _rb as ConsumerResolveBehavior
					if _c_behav.get_is_enabled() == false:
						continue
						
					var _amount : int = int(max(0, _c_behav.get_amount() + _terrain_tile_cost))
					if _d.has(_c_behav.identifier):
						_d[_c_behav.identifier] += _amount
					else:
						_d[_c_behav.identifier] = _amount
		
	set_consumption_amount(_d)

func set_production_amount(_dictionary : Dictionary):
	production_amount = _dictionary
	Events.emit_signal("production_amount_changed", production_amount)


func get_production_amount() -> Dictionary:
	return production_amount


func get_production_amount_by_resource(identifier : String) -> int:
	var _d : Dictionary = get_production_amount()
	if _d.has(identifier):
		return _d[identifier]
	return 0
		
		
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
			
	production_amount =_d


func on_resource_amount_added(_identifier, _amount) -> void:
	Events.emit_signal("player_resource_amount_added", _identifier, _amount)


func on_resource_amount_deducted(_identifier, _amount) -> void:
	Events.emit_signal("player_resource_amount_deducted", _identifier, _amount)	
