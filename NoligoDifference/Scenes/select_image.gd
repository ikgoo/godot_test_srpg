extends Control

@onready var grid_container = $ScrollContainer/GridContainer

@onready var texture_rect = preload("res://SubScenes/select_texture_rect.tscn")
@onready var select_scene_music_player = $SelectSceneMusicPlayer
@onready var audio_delay_play = $AudioDelayPlay
@onready var title_animation = $TextureRect/TitleAnimation
@onready var SceneParticles = $scene_particles

@onready var wait_timer = $WaitTimer


var selectImageList = []

func _ready():
	title_animation.play("ani");
	
	# 정상 이미지를 가져와 화면 출력
	for i in range(Global.dateList.size()):
		var curDate = Global.dateList[i]

		var tmptr : TextureButton = texture_rect.instantiate() as TextureButton

		var tex : ImageTexture = Global.LoadDownloadImage("main", curDate, 1)

		tmptr.texture_normal = tex
		var tttt = Global.mainJsonData["datas"][curDate]["difference_dtl"]
		tmptr.curData = tttt
		tmptr.curDate = curDate
		tmptr.connect("SelectImage", SelectImage)
		print(Global.mainJsonData["datas"][curDate])
		if !Global.mainJsonData["datas"][curDate].has("Success"):
			tmptr.SetIsClear(false)
		else:
			tmptr.SetIsClear(Global.mainJsonData["datas"][curDate]["Success"])
		selectImageList.append(tmptr)
		grid_container.add_child(tmptr)

	select_scene_music_player.MainMusicDelayPlay()

func SelectImage(img_name, curDate, gPosition, lPosition):
	var tmpData = Global.mainJsonData["datas"][curDate]
	# 완료된 경우 어떻게 처리할지 고민 해봐야 함
#	if ("Success" in tmpData) == true and tmpData["Success"] == true:
#		return

	Global.sctDate = curDate		# 선택된 날짜 등록
	
	select_scene_music_player.stop()
	SceneParticles.emit_signal("ParticleEvent", SceneParticles.ParticleName.CLICKHEART, gPosition, 0)
	
	# 연결 시그널을 모두 끊음
	for i in range(selectImageList.size()):
		selectImageList[i].disconnect("SelectImage", SelectImage)

	selectImageList.clear()

	SceneAudioPlayer.SceneAudioPlay(SceneAudioPlayer.SceneAudioList.CLICK, 0)
	wait_timer.start(1)
	await wait_timer.timeout	
	SceneTransition.change_scene(SceneTransition.SceneName.MAIN, SceneTransition.TransType.Fade)
	
