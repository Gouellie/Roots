extends Node

const MAX_TURNS : int = 30
const TURNS_PER_SEASON_CYCLES : int = 36
const TILE_HEALTH : int = 3
const PLANT_HEALTH : int = 2
const MASTER_PLANT_HEALTH : int = 3
const BASE_TILES_DRAW_COUNT : int = 4
const NUMB_PLANT_PLACED_TO_OPEN_STORE : int = 2

const FOG_REVEAL_RADIUS_MASTER_PLANT : int = 3
const FOG_REVEAL_RADIUS_TILE : int = 4

const SEASON_NAME := {
	"summer" : "Summer",
	"autumn" : "Autumn",
	"winter" : "Winter",
	"spring" : "Spring",
}

const SEASON_CONFIG : Dictionary = {
	1 : "summer",
	8 : "autumn",
	20 : "winter",
	28 : "spring",
}

const SEASON_CONSUMPTION_MODIFIER = {
	"summer" : {
		# WATER 4 - post gamejam stuff, should skip 1st season
	},
	"autumn" : {
		"soil":1
	},
	"winter" : {
		"soil":3,
		"water":2,
	},
	"spring" : {
		"water":2,
	},
}


var player_resource_manager : PlayerResourceManager
var entity_manager : EntityManager
var turn_manager : TurnManager
var ingredient_manager : IngredientManager
var upgrades_manager : UpgradesManager
var fog_manager : FogManager
var season_manager : SeasonManager

var is_upgrade_menu_opened : bool = false


func _init():
	Events.connect("init_player_resource_manager", self, "on_player_resource_manager_init")
	Events.connect("init_entity_manager", self, "on_entity_manager_init")
	Events.connect("init_turn_manager", self, "on_turn_manager_init")
	Events.connect("init_ingredient_manager", self, "on_ingredient_manager_init")
	Events.connect("init_fog_manager", self, "on_fog_manager_init")
	Events.connect("init_season_manager", self, "on_season_manager_init")


func on_player_resource_manager_init(_player_resource_manager):
	player_resource_manager = _player_resource_manager as PlayerResourceManager

func on_entity_manager_init(_entity_manager):
	entity_manager = _entity_manager as EntityManager
	
func on_turn_manager_init(_turn_manager):
	turn_manager = _turn_manager as TurnManager
	
func on_ingredient_manager_init(_ingredient_manager):
	ingredient_manager = _ingredient_manager as IngredientManager	
	
func on_fog_manager_init(_fog_manager):
	fog_manager = _fog_manager as FogManager
	
func on_season_manager_init(_season_manager):
	season_manager = _season_manager

func get_tile_draw_amount() -> int:
	return min(BASE_TILES_DRAW_COUNT + entity_manager.get_plants_count(), 10) as int

func display_game_info() -> void:
	var info = Info.new("tHrIVE_MIND")
	info.add_info("GAME BY : Lambo, Ivo Geelhoed, Cmacarthur, and Gouellie")
	info.add_info("MUSIC BY : airtone", 1)
	info.add_info("SONGS : aether, noodleSoup, snowdaze", 1)
	info.add_info("Thank you for playing!", 2)
	Events.emit_signal("info_request", info)
