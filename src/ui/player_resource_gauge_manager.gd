extends HBoxContainer

var resource_manager : ResourceManager
var resource_gauge : PackedScene = load("res://src/ui/resource_gauge.tscn")

func _init():
	Events.connect("init_player_resource_manager", self, "on_resource_manager_init")

func _ready():
	if resource_manager == null:
		Log.log_error(1, "No valid Player Resource Manager was found. No Gauges created.")
		return
	
	for _rsc in resource_manager.get_all_resources():
		var _node : ResourceNode = resource_manager.get_resource(_rsc) as ResourceNode
		if _node == null:
			continue
		
		var _instance = resource_gauge.instance()
		add_child(_instance)
		print(_node)
		_instance.resource_node = _node
	
func on_resource_manager_init(_resource_manager):
	resource_manager = _resource_manager as ResourceManager		
