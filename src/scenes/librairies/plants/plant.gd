extends Entity
class_name Plant

export (NodePath) var terrain_node_path
export (bool) var is_master_plant

onready var resource_manager = $ResourceManager

var health_node : ResourceNode
var head_tile_cellv : Vector2
var connected : bool = true setget set_is_connected,get_is_connected
var unrooted : bool = false
var fertile_soil : Entity

func _ready() -> void:
	if terrain_node_path:
		var terrain = get_node(terrain_node_path) as TileMap
		cellv = terrain.world_to_map(position)
		head_tile_cellv = cellv
		head_tile_cellv.y += 1
	
	if resource_manager:
		var _health : int = Globals.PLANT_HEALTH
		if is_master_plant:
			_health = Globals.MASTER_PLANT_HEALTH
			
		health_node = resource_manager.add_new_resource(Resources.HEALTH, _health)
		health_node.connect("node_depleted", self, "on_health_depleted")
		health_node.connect("node_update", self, "on_health_changed")


func apply_damage(_amount : int):
	if resource_manager:
		resource_manager.deduct_from_resource(Resources.HEALTH, _amount)

func on_health_depleted():
	if is_master_plant:
		Events.emit_signal("game_over", $PlantDamageResolveBehavior)
		return
		
	fertile_soil.plant_is_dead()
	Globals.entity_manager.plant_dead(cellv)
	self.queue_free()

func on_health_changed():
	pass

func _on_step_resolved(_step):
	# setup resolve steps no the Plant.scene, handle logic here
	pass


func set_is_connected(value : bool) -> void:
	connected = value
	$Disconnected.visible = not connected


func get_is_connected() -> bool:
	return connected


func _on_Area2D_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if not is_master_plant:
		set_is_connected(true)
		unrooted = false


func _on_Area2D_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if not is_master_plant:	
		set_is_connected(false)
		unrooted = true


func _input(event: InputEvent) -> void:
	if not has_mouse:
		return
	var info = Info.new("Master Plant" if is_master_plant else "Plant")
	info.add_info("Plants generate sunlights",1)
	info.add_info("Click any plant to open the Upgrade Shop",2)
	info.add_info("Your plant will die if your network doesn't produce enough soil", 3)
	info.add_info("If the Master Plant dies, it's game over", 4)
	Events.emit_signal("info_request", info)
	
	if Globals.entity_manager.builder_mode or Globals.entity_manager.eraser_mode:
		return
	if event.is_action_pressed("ui_accept"):
		Events.emit_signal("open_plant_shop")


func _on_MouseDetector_mouse_entered() -> void:
	has_mouse = true


func _on_MouseDetector_mouse_exited() -> void:
	has_mouse = false
