extends Node
class_name AudioManager

var track_01 = preload("res://assets/music/airtone_-_noodleSoup_1.mp3")
var track_02 = preload("res://assets/music/airtone_-_snowdaze.mp3")
var track_03 = preload("res://assets/music/airtone_-_aether_5.mp3")

export (AudioStream)var tile_place_audio : AudioStream
export (AudioStream)var tile_removed_audio : AudioStream
export (AudioStream)var tile_selected_audio : AudioStream
export (AudioStream)var tile_rotated_audio : AudioStream
export (AudioStream)var ui_click_disabled : AudioStream
export (AudioStream)var plant_spawned_audio : AudioStream
export (AudioStream)var received_damage_audio : AudioStream
export (AudioStream)var next_turn_audio : AudioStream
export (AudioStream)var mode_eraser_audio : AudioStream
export (AudioStream)var mode_building_audio : AudioStream
export (AudioStream)var season_changed_audio : AudioStream
export (AudioStream)var victory_audio : AudioStream
export (AudioStream)var defeat_audio : AudioStream

onready var background_track  : AudioStreamPlayer2D = $BackgroundTrack

var rng = RandomNumberGenerator.new()
var delay_between_tracks = 5.0
var current_delay = 0.0

var players = []

func _init():
	Events.connect("tile_placed", self, "on_tile_placed")
	Events.connect("tile_removed_at", self, "on_tile_removed_at")
	Events.connect("tile_selected", self, "on_tile_selected")
	Events.connect("tile_rotated", self, "on_tile_rotated")
	Events.connect("ui_click_disabled", self, "on_ui_click_disabled")
	Events.connect("spawn_plant", self, "on_plant_spawned")
	Turns.connect("turn_end_damage_received", self, "on_turn_end_damage_received")
	Turns.connect("turn_next", self, "on_next_turn")
	Events.connect("building_mode_toggle", self, "on_building_mode")
	Events.connect("eraser_mode_toggled", self, "on_eraser_mode")
	Events.connect("season_changed", self, "on_season_changed")
	Events.connect("game_over", self, "on_game_over")
	Events.connect("victory", self, "on_game_victory")

func clean_players():
	for _p in players:
		if _p is AudioStreamPlayer2D:
			var _player = _p as AudioStreamPlayer2D
			if _player.playing == false:
				_player.queue_free()
				players.remove(players.find(_player))

func _ready():
	rng.seed = hash(OS.get_time())
	_play_random_background_track()
	
func _play_random_background_track():
	var _random_track = rng.randi_range(0, 2)
	match _random_track:
		0:
			background_track.stream = track_01
		1:
			background_track.stream = track_02
		2:
			background_track.stream = track_03
	background_track.play(0)
	
func _process(delta):
	clean_players()
	if not background_track.playing:
		current_delay += delta
		if current_delay >= delay_between_tracks:
			_play_random_background_track()
			current_delay = 0.0


func play_audio_once(stream : AudioStream):
	var _player = AudioStreamPlayer2D.new()
	add_child(_player)
	_player.stream = stream
	_player.play(0)


func on_tile_placed(_tile):
	play_audio_once(tile_place_audio)
	
func on_tile_removed_at(_pos):
	play_audio_once(tile_removed_audio)
	
func on_tile_selected(_tile):
	play_audio_once(tile_selected_audio)
	
func on_tile_rotated(_tile):
	play_audio_once(tile_rotated_audio)	

func on_ui_click_disabled():
	play_audio_once(ui_click_disabled)
	
func on_plant_spawned(_soil, _pos):
	play_audio_once(plant_spawned_audio)
	
func on_turn_end_damage_received():
	play_audio_once(received_damage_audio)
	
func on_next_turn(_turn):
	play_audio_once(next_turn_audio)

func on_building_mode(_builder_mode : bool):
	if _builder_mode == false:
		play_audio_once(mode_eraser_audio)

func on_eraser_mode():
	play_audio_once(mode_building_audio)

func on_season_changed(_season):
	play_audio_once(season_changed_audio)

func on_game_over():
	play_audio_once(victory_audio)
	
func on_game_victory():
	play_audio_once(defeat_audio)
