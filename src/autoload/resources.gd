extends Node

const WATER : String = "water"
const SUNLIGHT : String = "sunlight"
const SOIL : String = "soil"
const HEALTH : String = "health"

func get_plant_cost(_num_plants : int) -> int:
	return _num_plants * _num_plants + 1
	
enum TILES {
	STRAIGHT = 1, 
	ELBOW = 2, 
	THREEWAY = 3, 
	FOURWAY = 4
}

const Tiles := {
	TILES.STRAIGHT : preload("res://src/scenes/librairies/tiles/types/tile_straight.tscn"),
	TILES.ELBOW : preload("res://src/scenes/librairies/tiles/types/tile_elbow.tscn"),
	TILES.THREEWAY : preload("res://src/scenes/librairies/tiles/types/tile_threeway.tscn"),
	TILES.FOURWAY : preload("res://src/scenes/librairies/tiles/types/tile_fourway.tscn"),
}

#placing cost
const Tiles_resource_cost = {
	TILES.STRAIGHT : {
		"sunlight": 1,
	},
	TILES.ELBOW : {
		"sunlight": 1,
	},
	TILES.THREEWAY : {
		"sunlight": 1,
	},
	TILES.FOURWAY : {
		"sunlight": 1,
	},
}

const icons = {
	"soil" : preload("res://assets/GUI/icons/icon_soil.png"),
	"sunlight" : preload("res://assets/GUI/icons/icon_sunlight.png"),
	"water" : preload("res://assets/GUI/icons/icon_water.png"),
}

const resource_color = {
	"soil" : Color.green,
	"sunlight" : Color.orange,
	"water" : Color.blue,
}

const INVALID_TILE_COST : int = 42

const tiles_cost = {
	"soft" : -1,
	"normal" : 0,
	"hard" : 1
}

func get_tile_cost(tile_name : String) -> int:
	for key in tiles_cost:
		# for tiles that blends between types, we take the cheapest one  
		if key in tile_name:
			return tiles_cost[key]
	return INVALID_TILE_COST
