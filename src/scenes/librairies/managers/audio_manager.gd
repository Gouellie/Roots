extends Node
class_name AudioManager

var track_01 = preload("res://assets/music/airtone_-_noodleSoup_1.mp3")
var track_02 = preload("res://assets/music/airtone_-_snowdaze.mp3")
var track_03 = preload("res://assets/music/airtone_-_aether_5.mp3")

export (AudioStream)var tile_place_audio : AudioStream
export (AudioStream)var tile_removed_audio : AudioStream

onready var background_track  : AudioStreamPlayer2D = $BackgroundTrack

var rng = RandomNumberGenerator.new()
var delay_between_tracks = 5.0
var current_delay = 0.0

var players = []

func _init():
	Events.connect("tile_placed", self, "on_tile_placed")
	Events.connect("tile_removed_at", self, "on_tile_removed_at")

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
	
