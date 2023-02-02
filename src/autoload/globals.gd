extends Node

var player_resource_manager : ResourceManager
var entity_manager : EntityManager

func _init():
	Events.connect("init_player_resource_manager", self, "on_player_resource_manager_init")
	Events.connect("init_entity_manager", self, "on_entity_manager_init")
	
func on_player_resource_manager_init(_resource_manager):
	player_resource_manager = _resource_manager as ResourceManager

func on_entity_manager_init(_entity_manager):
	entity_manager = _entity_manager as EntityManager

const CYCLE_LENGTH :int= 12
