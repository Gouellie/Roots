extends Reference
class_name Info

var header : String
var body := {}

func _init(_header : String) -> void:
	header = _header


func add_info(info : String, category : int = 0) -> void:
	if not body.has(category):
		body[category] = []
	body[category].append(info)
