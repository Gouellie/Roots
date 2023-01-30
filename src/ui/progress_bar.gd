extends ProgressBar


func _ready() -> void:
	Events.connect("progress_updated", self, "on_progress_update")


func on_progress_update(new_value : float) -> void:
	value = new_value
