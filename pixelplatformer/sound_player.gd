extends Node2D

@onready var audio_players = $AudioPlayers

const HURT : AudioStream = preload("res://Sounds/hurt.wav")
const JUMP : AudioStream = preload("res://Sounds/jump.wav")

func play_sound(sound : AudioStream):
	for audio_player : AudioStreamPlayer2D in audio_players.get_children():
		if not audio_player.playing:
			audio_player.stream = sound
			audio_player.play()
			break
