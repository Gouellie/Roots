extends Ingredient
class_name Harvestable

var identifier : String = "water"
var overlapping_tiles : Array = [] 

func _init():
	Events.connect("tile_placed", self, "on_tile_placed")
	# Erased signal does not yet exist
#	Events.connect("tile_erased", self, "on_tile_erased")
	
func on_tile_placed(_tile):
	var _t = _tile as Tile
	if _t == null:
		return
	
	var _i = _t.get_overlapping_ingredient() as Ingredient
	if _i == null:
		return
		
	overlapping_tiles.append(_t)
	
func on_tile_erased(_tile):
	var _t = _tile as Tile
	if _t == null:
		return
	var _index : int = overlapping_tiles.find(_t)
	if _index >= 0:
		overlapping_tiles.remove(_index)


func is_harvesting() -> bool:
	return len(overlapping_tiles) > 0
