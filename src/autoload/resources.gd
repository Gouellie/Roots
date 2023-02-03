extends Node

const WATER : String = "water"
const SUNLIGHT : String = "sunlight"
const SOIL : String = "soil"
const HEALTH : String = "health"

var num_plants = 1

func _init():
	Events.connect("spawn_plant", self, "on_plant_spawned")

func get_plant_cost() -> int:
	return num_plants * num_plants + 1

# doesn't trigger for MainPlant
func on_plant_spawned(_position):
	num_plants += 1
	Events.emit_signal("num_plants_changed", num_plants)
	
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
