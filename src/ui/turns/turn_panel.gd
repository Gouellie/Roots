extends Control

var _max_turns : int = 0

onready var progress_bar : ProgressBar = $VBoxContainer/CurrentTurnBar
onready var time_remaining_bar : ProgressBar = $VBoxContainer/TimeRemainingBar
onready var turn_label : Label = $VBoxContainer/CurrentTurnBar/Turn
onready var step_label : Label = $Step

var turn_manager : TurnManager

func _init():
	Turns.connect("turn_manager_initialized", self, "on_turn_manager_initialized")
	
func _ready():
	Turns.connect("step_next", self, "on_step_next")
	Turns.connect("turn_next", self, "on_turn_next")
		
	if turn_manager == null:
		Log.log_error(1, "No valid TurnManager was initialized.")
		return
	_max_turns = turn_manager.max_turns
	progress_bar.max_value = _max_turns	
	progress_bar.value = turn_manager.turn
	
	time_remaining_bar.min_value = 0
	time_remaining_bar.max_value = Turns.time_per_turn
	
	step_label.text = String(Turns.step_order[turn_manager.step])
	turn_label.text = String(turn_manager.turn)
	
func on_turn_manager_initialized(_turn_manager):
	turn_manager = _turn_manager as TurnManager
	turn_manager.connect("time_remaining_changed", self, "on_time_remaining_changed")
	
func on_step_next(_step):
	step_label.text = String(Turns.step_order[_step])
	
func on_turn_next(_turn):
	turn_label.text = String(_turn)
	progress_bar.value = _turn

func _on_EndTurn_Button_pressed():
	Turns.emit_signal("request_turn_end", self)

func on_time_remaining_changed(_time_remaining : float):
	time_remaining_bar.value = _time_remaining
