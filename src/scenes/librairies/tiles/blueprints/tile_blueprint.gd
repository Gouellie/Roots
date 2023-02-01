extends TileBlueprintBase
class_name TileBlueprint

export (int) var tile_index

onready var resource_manager : ResourceManager = $ResourceManager

var can_rotate : bool = true
var real_rotation : float = 0.0

func _ready() -> void:
	tile_scene = Resources.Tiles[tile_index]
	match tile_index:
		Resources.TILES.STRAIGHT:
			$Skin_Straight.visible = true

		Resources.TILES.ELBOW:
			$Skin_Elbow.visible = true

		Resources.TILES.THREEWAY:
			$Skin_ThreeWay.visible = true

		Resources.TILES.FOURWAY:
			$Skin_FourWay.visible = true
			can_rotate = false
		
	var _resource_cost = Resources.Tiles_resource_cost[tile_index]
	if resource_manager:
		for _rc in _resource_cost:
			var _cost = _resource_cost[_rc]
			resource_manager.resource_container.add_new_resource(_rc, _cost)

func can_afford(_consumer : ResourceManager) -> bool:
	return _consumer.can_consume_all(resource_manager)

func try_consume_resource_cost(_consumer : ResourceManager) -> bool:
	if can_afford(_consumer) == false:
		return false
	
	return _consumer.try_consume_all(self.resource_manager)


func rotate_blueprint(cw : bool) -> void:
	if not can_rotate:
		return
	var rot = 90.0 if cw else -90.0
	rotation_degrees = wrapf(rotation_degrees + rot, 0.0, 360.0) 
	# will eventually do a sprite change to simulate rotation instead of actually rotating node
	# this is the value that must be referenced, the rotation_degrees will not change
	real_rotation = rotation_degrees
