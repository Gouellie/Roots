extends Camera2D

const default_zoom := Vector2(1.0,1.0)

# how far in you can zoom
var zoom_min   : Vector2 = Vector2(0.3, 0.3)
# how far out you can zoom
var zoom_max   : Vector2 = Vector2(3.0, 3.0)
var zoom_speed : Vector2 = Vector2(0.2, 0.2)
var desired_zoom : Vector2 = zoom

var mouse_start_pos
var screen_start_position

var dragging = false
var lerping_to_selection = false

var lock_x : bool = false
var lock_y : bool = false


var camera_control_type :int=0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	zoom = lerp(zoom, desired_zoom, 0.1)


func _reset_camera() -> void:
	zoom = default_zoom
	desired_zoom = default_zoom
	position = Vector2.ZERO


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
			position.x = 0.0
		if lock_y:
			position.y = 0.0


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
