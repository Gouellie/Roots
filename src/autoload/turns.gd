extends Node

# warning-ignore:unused_signal
signal turn_manager_initialized(turn_manager)

# warning-ignore:unused_signal
signal step_next(step)

# warning-ignore:unused_signal
signal turn_next(turn)

# warning-ignore:unused_signal
signal request_turn_end(sender)

# warning-ignore:unused_signal
signal request_resolve(sender, step)

# warning-ignore:unused_signal
signal step_placing()

# warning-ignore:unused_signal
signal step_resource_receive()

# warning-ignore:unused_signal
signal step_resource_consume()

# warning-ignore:unused_signal
signal step_roots_sever()

# warning-ignore:unused_signal
signal step_roots_destroy()

# warning-ignore:unused_signal
signal step_condition_win()

# warning-ignore:unused_signal
signal step_condition_lose()

const step_order = {
	1: "step_placing",
	2: "step_resource_receive",
	3: "step_resource_consume",
	4: "step_roots_sever",
	5: "step_roots_destroy",
	6: "step_condition_win",
	7: "step_condition_lose",
}

const step_names = {
	1: "building",
	2: "income",
	3: "tax",
	4: "severing",
	5: "destroying",
	6: "win?",
	7: "lose?",
}
