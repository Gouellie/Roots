extends HBoxContainer

var resource_gauge : PackedScene = load("res://src/ui/resource_gauge.tscn")
export (Array)var visible_resources : Array = ["water", "soil"]

func _ready():
	if Globals.player_resource_manager == null:
		Log.log_error(1, "No valid Player Resource Manager was found. No Gauges created.")
		return
		
	for _rsc in Globals.player_resource_manager.get_resource_manager().get_all_resources():
		var _node : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource(_rsc) as ResourceNode
		if _node == null:
			continue
		
		if visible_resources.has(_node.identifier) == false:
			continue
		
		var _instance = resource_gauge.instance()
		add_child(_instance)
		_instance.resource_node = _node
	
