extends Node

var player_resource_manager : PlayerResourceManager
var entity_manager : EntityManager
var turn_manager : TurnManager

func _init():
	Events.connect("init_player_resource_manager", self, "on_player_resource_manager_init")
	Events.connect("init_entity_manager", self, "on_entity_manager_init")
	Events.connect("init_turn_manager", self, "on_turn_manager_init")
	
func on_player_resource_manager_init(_player_resource_manager):
	player_resource_manager = _player_resource_manager as PlayerResourceManager

func on_entity_manager_init(_entity_manager):
	entity_manager = _entity_manager as EntityManager
	
func on_turn_manager_init(_turn_manager):
	turn_manager = _turn_manager as TurnManager

const CYCLE_LENGTH :int= 12
