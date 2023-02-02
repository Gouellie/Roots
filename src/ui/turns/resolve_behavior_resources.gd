extends ResolveBehavior
class_name ResourceResolveBehavior

export (String)var identifier : String = "water"
export (int)var amount : int = 1

var player_resource_manager : ResourceManager

func _init():
	Events.connect("init_player_resource_manager", self, "on_player_resource_manager_init")
	amount = int(max(amount, 0))
	resolve_step = 2
	
func on_player_resource_manager_init(resource_manager):
	player_resource_manager = resource_manager as ResourceManager
	
func _execute_resolve_behavior():
	print("provide " + identifier + " >" + String(amount))
