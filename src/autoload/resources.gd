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

const INVALID_TILE : int = 42
const INVALID_TILE_COST : int = 42

enum TERRAIN_TYPES {
	SOFT = -1, 
	NORMAL = 0, 
	HARD = 1, 
}

const terrain_types = {
	"soft" : TERRAIN_TYPES.SOFT,
	"normal" : TERRAIN_TYPES.NORMAL,
	"hard" : TERRAIN_TYPES.HARD
}

const terrain_cost = {
	TERRAIN_TYPES.SOFT : TERRAIN_TYPES.SOFT,
	TERRAIN_TYPES.NORMAL : TERRAIN_TYPES.NORMAL,
	TERRAIN_TYPES.HARD : TERRAIN_TYPES.HARD,
}

const terrain_descriptions = {
	TERRAIN_TYPES.SOFT : {
		"name" : "Soft Terrain",
		"info" : ["Tiles placed here consume less water", "%d water consumed" % terrain_cost[TERRAIN_TYPES.SOFT]]
	},
	TERRAIN_TYPES.NORMAL : {
		"name" : "Normal Terrain",
		"info" : ["Tiles placed here consume their regular water intakes"]
	},
	TERRAIN_TYPES.HARD : {
		"name" : "Hard Terrain",
		"info" : ["Tiles placed here consume more water", "+%d water consumed" % terrain_cost[TERRAIN_TYPES.HARD]]
	}
}


func get_terrain_type(tile_name : String) -> int:
	for key in terrain_types:
		# for tiles that blends between types, we take the cheapest one  
		if key in tile_name:
			return terrain_types[key]
	return INVALID_TILE


func get_terrain_cost(tile_name : String) -> int:
	var tile_type = get_terrain_type(tile_name)
	if tile_type == INVALID_TILE:
		return INVALID_TILE_COST
	return terrain_cost[tile_type]


func get_terrain_descriptions(tile_name : String) -> Dictionary:
	var tile_type = get_terrain_type(tile_name)
	if tile_type == INVALID_TILE:
		return {
			"name" : "",
			"info" : [] 
		}
	return terrain_descriptions[tile_type]
