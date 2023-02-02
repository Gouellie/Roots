extends Node2D

onready var resource_manager = $ResourceManager

func _ready():
	Events.emit_signal("init_player_resource_manager", resource_manager)
