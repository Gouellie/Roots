extends Panel

onready var header :Label= $MarginContainer/VBoxContainer/ColorRect/Label_Header
onready var messages := $MarginContainer/VBoxContainer/Messages


func _ready() -> void:
	header.text = "tHrIVE_MIND"
	Events.connect("info_request", self, "on_info_request_received")


func on_info_request_received(info :Info) -> void:
	Utils.delete_children(messages)
	header.text = info.header
	var category_couts = info.body.size()
	var current = 0
	for category in info.body:
		for msg in info.body[category]:
			_add_message(msg)
		current += 1
		if current < category_couts:
			_add_separator()


func _add_message(msg : String) -> void:
	var label = Label.new()
	label.text = msg
	label.autowrap = true
	messages.add_child(label)


func _add_separator() -> void:
	var sep = ColorRect.new()
	sep.rect_min_size = Vector2(0.0, 2.0)
	messages.add_child(sep)
