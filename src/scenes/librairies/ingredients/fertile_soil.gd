extends Ingredient

var _root_tile : Tile
var fertilized : bool = false
var can_be_fertilized : bool = false

onready var sprite_attention := $Sprite_Attention
onready var resource_manager : ResourceManager = $ResourceManager
# ResourceControl is of type control and somehow is null on ready
onready var resource_control : ResourceControl
onready var animation_player :AnimationPlayer= $AnimationPlayer


func _init():
	Events.connect("num_plants_changed", self, "on_num_plants_changed")
	Events.connect("tile_removed_at", self, "on_tile_deleted")


func _ready() -> void:
	sprite_attention.visible = true
	_delay_animation()
	for child in get_children():
		if child is ResourceControl:
			resource_control = child
	animation_player.connect("animation_finished", self, "on_animation_finished")


func _delay_animation() -> void:
	yield(get_tree().create_timer(rand_range(0.1, 0.3)), "timeout")
	animation_player.play("idle")


func _process(delta: float) -> void:
	if fertilized:
		return	


func on_tile_deleted(at_position) -> void:
	if is_instance_valid(_root_tile):
		var show_button = _root_tile.connected
		_toggle_visibility(show_button, not fertilized)


func can_afford() -> bool:
	if resource_manager == null:
		return true

	return Globals.player_resource_manager.get_resource_manager().can_consume_all(resource_manager)

func try_consume_resources() -> bool:
	if resource_manager == null:
		return false

	return Globals.player_resource_manager.get_resource_manager().try_consume_all(resource_manager)
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	if fertilized:
		return	
	_toggle_visibility(true, not fertilized)
	_root_tile = area.owner as Tile


func _on_Area2D_area_exited(area: Area2D) -> void:
	if fertilized:
		return
	_toggle_visibility(false, not fertilized)
	_root_tile = area.owner	as Tile


func _on_Button_pressed() -> void:
	if _root_tile == null:
		return
	if not _root_tile.connected:
		return 
		
	if can_afford() == false:
		return
	
	if try_consume_resources() == false:
		# this should never trigger
		return
			
	Events.emit_signal("spawn_plant", self, position)
	fertilized = true
	_toggle_visibility(false,false)


func _toggle_visibility(show_button, show_icon) -> void:
	can_be_fertilized = show_button
	sprite_attention.visible = show_icon
	resource_control.visible = show_button and not fertilized
	if show_button:
		animation_player.play("buy_ease_in")


func on_animation_finished(animation_name) -> void:
	if animation_name == "buy_ease_in":
		animation_player.play("idle_buy")


func on_num_plants_changed(_num_plants):
	if resource_manager as ResourceManager:
		var _rm : ResourceManager = resource_manager
		for _identifier in _rm.get_all_resources():
			_rm.get_resource(_identifier).set_value(Resources.get_plant_cost(_num_plants)) 


func plant_is_dead() -> void:
	fertilized = false
	animation_player.play("idle")	
	_toggle_visibility(false, true)


func _input(event: InputEvent) -> void:
	if fertilized or not has_mouse:
		return
	if can_be_fertilized and event.is_action_pressed("ui_accept"):
		_on_Button_pressed()
