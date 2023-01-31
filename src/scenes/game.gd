extends Node2D

var progress : float = 0 

func _ready() -> void:
	Events.connect("tick", self, "on_tick")


func on_tick() -> void:
	progress += 1
	if progress == Globals.CYCLE_LENGTH:
		_game_over()
	Events.emit_signal("progress_updated", progress)


func _game_over() -> void:
	Events.emit_signal("game_over")
