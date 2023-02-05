extends Node

var resolve_behaviors : Array = []

const time_per_turn : float = 45.0

# warning-ignore:unused_signal
signal turn_end_damage_received

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
signal step_plant_damage()

# warning-ignore:unused_signal
signal step_roots_damage_severed()

# warning-ignore:unused_signal
signal step_roots_damage_connected()

# warning-ignore:unused_signal
signal step_condition_win()

# warning-ignore:unused_signal
signal step_condition_lose()

enum STEP_ORDER {
	placing = 1,
	resources_produce = 2,
	resources_consume = 3,
	roots_damage_severed = 4,
	roots_damage_connected = 5,
	plant_damage = 6,
	condition_win = 7,
	condition_lose = 8,
}

# careful when renaming, it's using the "VALUE" to find the corresponding signal
const step_order = {
	STEP_ORDER.placing: "step_placing",
	STEP_ORDER.resources_produce: "step_resource_produce",
	STEP_ORDER.resources_consume: "step_resource_consume",
	STEP_ORDER.roots_damage_severed: "step_roots_damage_severed",
	STEP_ORDER.roots_damage_connected: "step_roots_damage_connected",
	STEP_ORDER.plant_damage: "step_plant_damage",
	STEP_ORDER.condition_win: "step_condition_win",
	STEP_ORDER.condition_lose: "step_condition_lose",
}
