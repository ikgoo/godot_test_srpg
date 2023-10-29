extends AudioStreamPlayer

@onready var audio_delay_play = $"../AudioDelayPlay"


# 메인 음악 딜레이 플레이
func MainMusicDelayPlay():
	audio_delay_play.start(0.5)
	await audio_delay_play.timeout
	play()
	


func _on_finished():
	MainMusicDelayPlay()
