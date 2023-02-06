extends Panel
class_name TilePanel

export (PackedScene) var tile_scene

var is_hovering : bool = false
var is_selected : bool = false setget set_is_selected

export var random_tile : bool = true
export var tile_index : int = 0

onready var tile_blueprint : TileBlueprint
onready var disabled_popup := $Position2D_Popup
onready var tween : Tween = $Position2D_Popup/Tween

func _init():
	Events.connect("init_player_resource_manager", self, "on_init_player_resource_manager")
	Events.connect("tile_placed", self, "on_tile_placed")
	Events.connect("player_resource_amount_deducted", self, "on_resource_deducted")
	Turns.connect("turn_next", self, "on_next_turn")

		
func _ready() -> void:
	disabled_popup.visible = false
	tile_blueprint = tile_scene.instance() as TileBlueprint
	tile_blueprint.tile_index = randi()%4+1 if random_tile else tile_index
	tile_blueprint.scale = Vector2(0.5, 0.5)
	tile_blueprint.position = $TileCenterPos.rect_position
	add_child(tile_blueprint)


func on_init_player_resource_manager(_player_resource_manager):
	for _rsc in Globals.player_resource_manager.get_resource_manager().get_all_resources():
		var _node = _rsc as ResourceNode
		if _node == null:
			continue
		
		_node.connect("node_update", self, "on_resource_updated")


func on_resource_updated():
	update_color()

func on_tile_placed(_tile):
	update_color()
	
func on_resource_deducted(id, amount):
	if id == Resources.SUNLIGHT:
		update_color()
	
func on_next_turn(_turn):
	update_color()


func update_color():
	var cannot_afford = not tile_blueprint.can_afford()
	disabled_popup.visible = cannot_afford and is_hovering
	if cannot_afford:
		if is_hovering:
			tween.interpolate_property(disabled_popup, "scale", disabled_popup.scale, Vector2(1.0, 1.0), 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
			tween.start()
		else :
			disabled_popup.scale = Vector2(0.7, 0.7)
	if cannot_afford:
		var style = self.get_stylebox("disabled")
		add_stylebox_override("panel", style)
	elif is_selected:
		var style = self.get_stylebox("selected")
		add_stylebox_override("panel", style)
	elif is_hovering:
		var style = self.get_stylebox("mouse_over")
		add_stylebox_override("panel", style)
	else:
		add_stylebox_override("panel", null)


func _on_TilePanel_mouse_entered() -> void:
	var style = self.get_stylebox("mouse_over")
	add_stylebox_override("panel", style)
	
	is_hovering = true
	update_color()
	
	var info = Info.new(tile_blueprint.tile_name)
	info.add_info("Connect the tile to your root network")
	info.add_info("It cost 1 Sunlight to place a tile")
	
	for detail in tile_blueprint.details:
		info.add_info(detail, 1)

	if not tile_blueprint.can_afford():
		info.add_info("You do not have enough Sunlight to afford the Tile", 2)	
	
	Events.emit_signal("info_request", info)


func _on_TilePanel_mouse_exited() -> void:
	is_hovering = false
	update_color()	


func _on_TilePanel_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_accept") :
		return
	set_is_selected(!is_selected)
	if tile_blueprint.can_afford():
		Events.emit_signal("tilepanel_selected", self, tile_blueprint if is_selected else null)
	else:
		Events.emit_signal("ui_click_disabled")


func set_is_selected(value : bool) -> void:
	if tile_blueprint.can_afford() == false:
		is_selected = false
	else:
		is_selected = value
	update_color()

