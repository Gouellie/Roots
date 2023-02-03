extends Node2D
class_name UpgradesManager

var sun_level : int = 0
var water_level : int = 0
var nutrients_level : int = 0

func _init() -> void:
	Globals.upgrades_manager = self


func _ready() -> void:
	Events.connect("shop_buy_sun_upgrade", self, "on_sun_upgraded")
	Events.connect("shop_buy_water_upgrade", self, "on_water_upgraded")
	Events.connect("shop_buy_soil_upgrade", self, "on_nutrients_upgraded")


func on_sun_upgraded(level) -> void:
	sun_level = level


func on_water_upgraded(level) -> void:
	water_level = level


func on_nutrients_upgraded(level) -> void:
	nutrients_level = level
