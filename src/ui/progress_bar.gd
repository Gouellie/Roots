extends ProgressBar


func _ready() -> void:
	max_value = Globals.CYCLE_LENGTH
	Events.connect("progress_updated", self, "on_progress_update")


func on_progress_update(new_value : float) -> void:
	value = new_value
