extends Control

onready var panel = $Panel
onready var description = $Panel/CenterContainer/VBoxContainer/Description

onready var winter = $Panel/CenterContainer/VBoxContainer/Winter
onready var autumn = $Panel/CenterContainer/VBoxContainer/Autumn
onready var spring = $Panel/CenterContainer/VBoxContainer/Spring

var visible_time = 4.0
var timer = 0.0
var is_started = false
var has_timer = false

func _init():
	Events.connect("season_changed", self, "on_season_changed")

func _ready():
	end_notif()

func _process(delta):
	if has_timer == false:
		return
		
	if is_started == false:
		return
	
	timer += delta
	if timer >= visible_time:
		end_notif()


func on_season_changed(_season):
	description.text = _season
	
	winter.visible = false
	autumn.visible = false
	spring.visible = false
	match _season:
		"winter":
			winter.visible = true
		
		"autumn":
			autumn.visible = true
			
		"spring":
			spring.visible = true
			
			
	start_notif()


func start_notif():
	panel.visible = true
	is_started = true
	timer = 0.0
	
	
func end_notif():
	panel.visible = false
	is_started = false
	


func _on_Button_button_down():
	end_notif()
