extends Node

const TILE_HEALTH : int = 3
const PLANT_HEALTH : int = 2
const MASTER_PLANT_HEALTH : int = 3
const BASE_TILES_DRAW_COUNT : int = 3

const FOG_REVEAL_RADIUS_TILE : int = 4


var player_resource_manager : PlayerResourceManager
var entity_manager : EntityManager
var turn_manager : TurnManager
var ingredient_manager : IngredientManager
var upgrades_manager : UpgradesManager

var is_upgrade_menu_opened : bool = false


func _init():
	Events.connect("init_player_resource_manager", self, "on_player_resource_manager_init")
	Events.connect("init_entity_manager", self, "on_entity_manager_init")
	Events.connect("init_turn_manager", self, "on_turn_manager_init")
	Events.connect("init_ingredient_manager", self, "on_ingredient_manager_init")


func on_player_resource_manager_init(_player_resource_manager):
	player_resource_manager = _player_resource_manager as PlayerResourceManager

func on_entity_manager_init(_entity_manager):
	entity_manager = _entity_manager as EntityManager
	
func on_turn_manager_init(_turn_manager):
	turn_manager = _turn_manager as TurnManager
	
func on_ingredient_manager_init(_ingredient_manager):
	ingredient_manager = _ingredient_manager as IngredientManager	

func get_tile_draw_amount() -> int:
	return min(BASE_TILES_DRAW_COUNT + entity_manager.get_plants_count(), 10) as int

func display_game_info() -> void:
	var info = Info.new("tHrIVE_MIND")
	Events.emit_signal("info_request", info)
