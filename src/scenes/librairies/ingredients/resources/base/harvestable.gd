extends Ingredient
class_name Harvestable

var identifier : String = "water"

func is_harvesting() -> bool:
	for _t in Globals.entity_manager.get_connected_root_tiles():
		var _tile = _t as Tile
		if _tile == null:
			continue
		var _i = _tile.get_overlapping_ingredient()
		if _i == self:
			return true
	return false
