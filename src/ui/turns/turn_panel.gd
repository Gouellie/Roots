extends Control

var _max_turns : int = 0

onready var progress_bar : ProgressBar = $VBoxContainer/CurrentTurnBar
onready var turn_label : Label = $VBoxContainer/CurrentTurnBar/Turn
onready var end_turn_button : Button = $EndTurn_Button
onready var animation : AnimationPlayer = $AnimationPlayer


var turn_manager : TurnManager

func _init():
	Turns.connect("turn_manager_initialized", self, "on_turn_manager_initialized")
	
func _ready():
	end_turn_button.disabled = true
	Events.connect("tile_placed", self, "on_first_tile_placed")
	Events.connect("player_resource_amount_deducted", self, "on_player_resource_amount_deducted")
	Turns.connect("step_next", self, "on_step_next")
	Turns.connect("turn_next", self, "on_turn_next")
		
	if turn_manager == null:
		Log.log_error(1, "No valid TurnManager was initialized.")
		return
	_max_turns = Globals.MAX_TURNS
	progress_bar.max_value = _max_turns	
	progress_bar.value = turn_manager.turn

	turn_label.text = String(turn_manager.turn)
	
func on_turn_manager_initialized(_turn_manager):
	turn_manager = _turn_manager as TurnManager
	turn_manager.connect("time_remaining_changed", self, "on_time_remaining_changed")
	
func on_step_next(_step):
	pass

	
func on_turn_next(_turn):
	animation.play("idle")
	turn_label.text = String(_turn)
	progress_bar.value = _turn

func _on_EndTurn_Button_pressed():
	Turns.emit_signal("request_turn_end", self)

func on_time_remaining_changed(_time_remaining : float):
	pass

func on_first_tile_placed(tile) -> void:
	end_turn_button.disabled = false


func _on_EndTurn_Button_mouse_entered() -> void:
	var info = Info.new("End Turn")
	info.add_info("Move on to the next turn")
	info.add_info("Make sure that your network has enough water and soil to sustain itself or your Roots and Plants will receive damage", 1)
	Events.emit_signal("info_request", info)


func _on_TurnPanel_mouse_entered() -> void:
	var info = Info.new("Current Turn")
	info.add_info("Survive %d turns to win the game" % _max_turns)
	Events.emit_signal("info_request", info)


func on_player_resource_amount_deducted(resource, amount) -> void:
	if resource != Resources.SUNLIGHT:
		return
	var money_left = Globals.player_resource_manager.get_resource_manager().can_consume(Resources.SUNLIGHT, 1)
	if not money_left:
		animation.play("pulse")

