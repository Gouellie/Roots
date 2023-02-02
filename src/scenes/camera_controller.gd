extends Camera2D

export (NodePath) var zoom_entity

const default_zoom := Vector2(1.0,1.0)

# how far in you can zoom
var zoom_min   : Vector2 = Vector2(0.3, 0.3)
# how far out you can zoom
var zoom_max   : Vector2 = Vector2(2.5, 2.5)
var zoom_speed : Vector2 = Vector2(0.2, 0.2)
var desired_zoom : Vector2 = zoom

var h_limits := Vector2(-900.0, 900.0)
var w_limits := Vector2(-2500.0, 2500.0)

var mouse_start_pos
var screen_start_position

var dragging = false
var lerping_to_selection = false

var lock_x : bool = false
var lock_y : bool = false


var camera_control_type :int=0

onready var camera_center : Vector2
onready var camera_offset : Vector2


func _ready() -> void:
	camera_offset = OS.window_size * 0.5
	w_limits += Vector2(camera_offset.x, camera_offset.x)
	h_limits += Vector2(camera_offset.y, camera_offset.y)
	var node = get_node(zoom_entity)
	if node:
		camera_center = node.position
		center_on_position(camera_center)


func _process(_delta: float) -> void:
	zoom = lerp(zoom, desired_zoom, 0.1)


func _reset_camera() -> void:
	zoom = default_zoom
	desired_zoom = default_zoom
	center_on_position(camera_center)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_control"):
		_change_camera_control_type()
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if desired_zoom > zoom_min:
					desired_zoom -= zoom_speed
			if event.button_index == BUTTON_WHEEL_DOWN:
				if desired_zoom < zoom_max:
					desired_zoom += zoom_speed
	if event.is_action("camera_pan"):
		lerping_to_selection = false
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
		if lock_x:
			position.x = camera_center.x - camera_offset.x
		if lock_y:
			position.y = camera_center.y - camera_offset.y
		position.x = clamp(position.x, w_limits.x, w_limits.y)
		position.y = clamp(position.y, h_limits.x, h_limits.y)


func _change_camera_control_type() -> void:
	_reset_camera()
	camera_control_type = wrapi(camera_control_type+1, 0, 4)
	match camera_control_type:
		0:
			lock_x = false
			lock_y = false
			print("camera control type : default")
		1:
			lock_x = true
			lock_y = false
			print("camera control type : x lock")		
		2:
			lock_x = false
			lock_y = true
			print("camera control type : y lock")
		3:
			lock_x = true
			lock_y = true
			print("camera control type : no pan")


func center_on_position(pos : Vector2) -> void:
	position = pos - camera_offset
