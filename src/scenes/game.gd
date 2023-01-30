extends Node2D

var progress : float = 0 
var is_ticking : bool = false

onready var ticker : Timer = $Ticker


func _ready() -> void:
	Events.connect("is_ticking_toggled", self, "on_is_ticking_toggled")
	ticker.start()


func _on_Ticker_timeout() -> void:
	if not is_ticking:
		return
	if progress == 100:
		_game_over()
	progress += 1
	Events.emit_signal("progress_updated", progress)
	

func _game_over() -> void:
	Events.emit_signal("game_over")


func on_is_ticking_toggled(new_value : bool) -> void:
	is_ticking = new_value
