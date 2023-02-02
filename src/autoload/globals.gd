extends Node

var player_resource_manager : ResourceManager

func _init():
		Events.connect("init_player_resource_manager", self, "on_player_resource_manager_init")
	
func on_player_resource_manager_init(_resource_manager):
	player_resource_manager = _resource_manager as ResourceManager

const CYCLE_LENGTH :int= 12
