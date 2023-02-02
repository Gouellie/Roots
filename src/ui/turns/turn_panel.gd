extends Control

var _max_turns : int = 0

onready var progress_bar : ProgressBar = $ProgressBar
onready var turn_label : Label = $Turn
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
	step_label.text = String(Turns.step_names[turn_manager.step])
	turn_label.text = String(turn_manager.turn)
	
func on_turn_manager_initialized(_turn_manager):
	turn_manager = _turn_manager as TurnManager
	
func on_step_next(_step):
	step_label.text = String(Turns.step_names[_step])
	
func on_turn_next(_turn):
	turn_label.text = String(_turn)
	progress_bar.value = _turn

func _on_EndTurn_Button_pressed():
	Turns.emit_signal("request_turn_end", self)
	pass