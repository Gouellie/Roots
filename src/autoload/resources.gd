extends Node


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

const Tiles_resource_cost = {
	TILES.STRAIGHT : {
		"water": 1,
		"soil": 1,
	},
	TILES.ELBOW : {
		"water": 1,
		"soil": 1,
	},
	TILES.THREEWAY : {
		"water": 2,
		"soil": 1,
	},
	TILES.FOURWAY : {
		"water": 2,
		"sunlight": 2,
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
