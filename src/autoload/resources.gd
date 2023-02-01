extends Node


enum TILES {
	STRAIGHT = 1, 
	ELBOW = 2, 
	THREEWAY = 3, 
	FOURWAY = 4}


const Tiles := {
	TILES.STRAIGHT : preload("res://src/scenes/librairies/tiles/types/tile_straight.tscn"),
	TILES.ELBOW : preload("res://src/scenes/librairies/tiles/types/tile_elbow.tscn"),
	TILES.THREEWAY : preload("res://src/scenes/librairies/tiles/types/tile_threeway.tscn"),
	TILES.FOURWAY : preload("res://src/scenes/librairies/tiles/types/tile_fourway.tscn"),
}
