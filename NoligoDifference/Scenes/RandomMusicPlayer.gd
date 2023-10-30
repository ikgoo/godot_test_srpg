extends AudioStreamPlayer

@export var backMusicList : Array[AudioStream]

@onready var dliay_music = $"../DliayMusic"


func _ready():
	randomize()

# 메인 음악 딜레이 플레이
func MainMusicDelayPlay():
	dliay_music.start(0.5)
	await dliay_music.timeout
	stream = backMusicList[randi_range(0, backMusicList.size()-1)]
	play()
	

func _on_finished():
	MainMusicDelayPlay()
