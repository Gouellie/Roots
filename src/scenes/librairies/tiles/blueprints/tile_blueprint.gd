extends TileBlueprintBase
class_name TileBlueprint

export (int) var tile_index


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
