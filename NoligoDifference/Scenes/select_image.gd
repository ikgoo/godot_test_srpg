extends Control

@onready var grid_container = $ScrollContainer/GridContainer
@onready var audio_delay_play = $AudioDelayPlay

@onready var texture_rect = preload("res://SubScenes/texture_rect.tscn")

var selectImageList = []

func _ready():
	# 정상 이미지를 가져와 화면 출력
	for i in range(Global.dateList.size()):
		var curDate = Global.dateList[i]

		var tmptr : TextureButton = texture_rect.instantiate() as TextureButton

		var tex : ImageTexture = Global.LoadDownloadImage("main", curDate, 1)

		tmptr.texture_normal = tex
		var tttt = Global.mainJsonData["datas"][curDate]["data"]
		tmptr.curData = Global.mainJsonData["datas"][curDate]["data"]
		tmptr.curDate = curDate
		tmptr.connect("SelectImage", SelectImage)

		selectImageList.append(tmptr)
		grid_container.add_child(tmptr)

	MainMusicDelayPlay()

func SelectImage(img_name, curDate, gPosition, lPosition):
	var tmpData = Global.mainJsonData["datas"][curDate]
	# 완료된 경우 어떻게 처리할지 고민 해봐야 함
#	if ("Success" in tmpData) == true and tmpData["Success"] == true:
#		return

	Global.sctDate = curDate		# 선택된 날짜 등록
	
	$AudioStreamPlayer.stop()
	SceneParticles.emit_signal("ParticleEvent", SceneParticles.ParticleName.CLICKHEART, gPosition, 0)
	
	# 연결 시그널을 모두 끊음
	for i in range(selectImageList.size()):
		selectImageList[i].disconnect("SelectImage", SelectImage)

	selectImageList.clear()

	SceneAudioPlayer.SceneAudioPlay(SceneAudioPlayer.SceneAudioList.CLICK, 0)
	SceneTransition.change_scene(SceneTransition.SceneName.MAIN, SceneTransition.TransType.Fade)
	

# 메인 음악 딜레이 플레이
func MainMusicDelayPlay():
	audio_delay_play.start(0.5)
	await audio_delay_play.timeout
	$AudioStreamPlayer.play()
	


func _on_audio_stream_player_finished():
	MainMusicDelayPlay()
