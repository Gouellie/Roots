extends HBoxContainer

var resource_gauge : PackedScene = load("res://src/ui/resource_gauge.tscn")
export (Array)var visible_resources : Array = ["water", "soil"]

func _ready():
	if Globals.player_resource_manager == null:
		Log.log_error(1, "No valid Player Resource Manager was found. No Gauges created.")
		return
	var _resources : Dictionary = Globals.player_resource_manager.get_resource_manager().get_all_resources()
	_add_gauge(Resources.SUNLIGHT)
	_add_gauge(Resources.WATER)
	_add_gauge(Resources.SOIL)
	
func _add_gauge(_identifier : String):
	var _node : ResourceNode = Globals.player_resource_manager.get_resource_manager().get_resource(_identifier) as ResourceNode
	if _node == null:
		return
	
	if visible_resources.has(_node.identifier) == false:
		return
	
	var _instance = resource_gauge.instance()
	add_child(_instance)
	_instance.resource_node = _node
