extends Control

@onready var grid_container = $ScrollContainer/GridContainer
@onready var audio_delay_play = $AudioDelayPlay

@onready var texture_rect = preload("res://SubScenes/texture_rect.tscn")

var selectImageList = []

func _ready():
	
	# 정상 이미지를 가져와 화면 출력
	for i in range(SingletonMainData.dateList.size()):
		var curDate = SingletonMainData.dateList[i]
		
		var tmptr : TextureRect = texture_rect.instantiate() as TextureRect
		
		var tex : ImageTexture = SingletonMainData.LoadDownloadImage(curDate, 1)
		
		tmptr.texture = tex
		var tttt = SingletonMainData.mainJsonData["datas"][curDate]["data"]
		tmptr.curData = SingletonMainData.mainJsonData["datas"][curDate]["data"]
		tmptr.curDate = curDate
		tmptr.connect("SelectImage", SelectImage)
		
		selectImageList.append(tmptr)
		grid_container.add_child(tmptr)
	
	audio_delay_play.start(0.5)
	await audio_delay_play.timeout
	$AudioStreamPlayer.autoplay = true
	$AudioStreamPlayer.play()
	

func SelectImage(img_type, curDate, gPosition, lPosition, event):
	var tmpData = SingletonMainData.mainJsonData["datas"][curDate]
	if ("Success" in tmpData) == true and tmpData["Success"] == true:
		return

	SingletonMainData.sctDate = curDate		# 선택된 날짜 등록
	
	$AudioStreamPlayer.autoplay = false
	$AudioStreamPlayer.stop()
	SceneParticles.emit_signal("ParticleEvent", SceneParticles.ParticleName.CLICKHEART, gPosition, 0)
	
	# 연결 시그널을 모두 끊음
	for i in range(selectImageList.size()):
		selectImageList[i].disconnect("SelectImage", SelectImage)

	selectImageList.clear()

	SceneAudioPlayer.SceneAudioPlay(SceneAudioPlayer.SceneAudioList.CLICK, 0)
	SceneTransition.change_scene(SceneTransition.SceneName.MAIN, 1.1)
	
