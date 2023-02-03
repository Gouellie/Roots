extends Entity
class_name Plant

export (NodePath) var terrain_node_path
export (bool) var is_master_plant

var head_tile_cellv : Vector2
var connected : bool = true setget set_is_connected,get_is_connected
var unrooted : bool = false

func _ready() -> void:
	if terrain_node_path:
		var terrain = get_node(terrain_node_path) as TileMap
		cellv = terrain.world_to_map(position)
		head_tile_cellv = cellv
		head_tile_cellv.y += 1


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
	info.add_info("Connect roots to your plant")
	info.add_info("Each additional Plants generate Sun token")
	info.add_info("Each additional Plants generate Sun token", 1)
	Events.emit_signal("info_request", info)
	
	if Globals.entity_manager.builder_mode or Globals.entity_manager.eraser_mode:
		return
	if event.is_action_pressed("ui_accept"):
		Events.emit_signal("open_plant_shop")


func _on_MouseDetector_mouse_entered() -> void:
	has_mouse = true


func _on_MouseDetector_mouse_exited() -> void:
	has_mouse = false
