extends Node

var resolve_behaviors : Array = []

const time_per_turn : float = 45.0

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
signal step_resource_produce()

# warning-ignore:unused_signal
signal step_resource_consume()

# warning-ignore:unused_signal
signal step_roots_damage_severed()

# warning-ignore:unused_signal
signal step_roots_damage_connected()

# warning-ignore:unused_signal
signal step_condition_win()

# warning-ignore:unused_signal
signal step_condition_lose()

enum STEP_ORDER {
	resources_produce = 1,
	placing = 2,
	resources_consume = 3,
	roots_damage_severed = 4,
	roots_damage_connected = 5,
	condition_win = 6,
	condition_lose = 7,
}

# careful when renaming, it's using the "VALUE" to find the corresponding signal
const step_order = {
	1: "step_resource_produce",
	2: "step_placing",
	3: "step_resource_consume",
	4: "step_roots_damage_severed",
	5: "step_roots_damage_connected",
	6: "step_condition_win",
	7: "step_condition_lose",
}
