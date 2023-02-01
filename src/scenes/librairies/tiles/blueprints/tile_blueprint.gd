extends TileBlueprintBase
class_name TileBlueprint

export (int) var tile_index

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


func rotate_blueprint(cw : bool) -> void:
	if not can_rotate:
		return
	var rot = 90.0 if cw else -90.0
	rotation_degrees = wrapf(rotation_degrees + rot, 0.0, 360.0) 
	# will eventually do a sprite change to simulate rotation instead of actually rotating node
	# this is the value that must be referenced, the rotation_degrees will not change
	real_rotation = rotation_degrees
