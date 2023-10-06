extends AudioStreamPlayer

# 디로잉~~
@onready var decidemp : AudioStream = preload("res://Assets/Sounds/Effices/decidemp3-14575.mp3")
# 게임 보너스 
@export var gameBbonus : AudioStream = preload("res://Assets/Sounds/Effices/game-bonus-144751.mp3")
# 게임 보너스 
@export var levelPassed : AudioStream = preload("res://Assets/Sounds/Effices/level-passed-143039.mp3")
# 게임 보너스 
@export var click : AudioStream = preload("res://Assets/Sounds/Effices/click-124467.mp3")

# 소리 리스트
var audioList
enum SceneAudioList {
	DECIDEMP,
	GAMEBONUS,
	LEVELPASSED,
	CLICK,
}

# 기본 대기 시간
var defaultDelayTime = 0.5

func _ready():
	audioList = [ decidemp, gameBbonus, levelPassed, click ]

# 씬 차원에서 소리를 내야가는 경우
# 일반적으로 화면 시작이나 화면 나깔때 경제선에 애매한 것들 처리
func SceneAudioPlay(sctAudtio : SceneAudioList, delayTime : float):
	if delayTime == -1:
		$Timer.wait_time = defaultDelayTime
		$Timer.start()
		await $Timer.timeout
	elif delayTime != 0:
		$Timer.wait_time = delayTime
		$Timer.start()
		await $Timer.timeout
	
	
	if playing == true:
		stop()
	
	stream = audioList[sctAudtio]
	play()
	
