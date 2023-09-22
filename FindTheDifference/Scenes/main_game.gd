extends Control

@export var backMusicList : Array[AudioStream]

@onready var random_music_player = $RandomMusicPlayer

@onready var left_image = $LeftImage
@onready var right_image = $RightImage

@onready var texture_rect = preload("res://SubScenes/texture_rect.tscn")

@onready var circle = preload("res://Art/circle.jpg")
@onready var options = $Options
# 프로그래스바
@onready var progress_bar = $ProgressBar
# 메인 게임내 애니메이션(카운트다운)
@onready var game_main_player = $GameMainPlayer
# 플레이어 생명력(UI)
@onready var player_full_heart = $HUD/PlayerFullHeart

#게임 오버시 소리
@onready var game_end_sfx_player = $GameEndSFXPlayer
@onready var gameFail = preload("res://Sounds/kl-peach-game-over-i-132096.mp3")			# 게임 실패
@onready var gameSuccess = preload("res://Sounds/success-fanfare-trumpets-6185.mp3")	# 게임 성공

@onready var crossAct = preload("res://SubScenes/cross.tscn")	# 틀렸을때 이미지

# 맞춘수
var score : int = 0

# 현재 화면의 이미지 데이터
var currentGameData

# 현재 판에서 표현된 틀린부분의 순번을 담고 있는 배열
var currentGameDiffList = []

# progress bar 속도를 위해 사용
var tween : Tween = null
# 플레이어 생명
var playerLife = 3

func _ready():
	options.connect("GoMain", PreGoMain)
	
	randomize()
	
	var curDate = SingletonMainData.sctDate
	# 최초에 맞춘내용 초기화 필요
	currentGameData = SingletonMainData.mainJsonData["datas"][curDate]["data"]
	# 맞춘부분 데이터 초기화
	for i in range(currentGameData.size()):
		currentGameData[i]["checked"] = false
		
	var tex_main : ImageTexture = SingletonMainData.LoadDownloadImage("main", curDate, -1)
	left_image.texture_normal = tex_main
	left_image.curData = currentGameData
	left_image.curDate = curDate
	left_image.img_type = "background"
	left_image.connect("SelectImage", SelectImage)
	right_image.texture_normal = tex_main
	right_image.curData = SingletonMainData.mainJsonData["datas"][curDate]["data"]
	right_image.curDate = curDate
	right_image.img_type = "background"
	right_image.connect("SelectImage", SelectImage)

	
	# 랜덤하게 5개 틀린부분 가져오기
	var data_array = range(currentGameData.size())
	data_array.shuffle()
	currentGameDiffList = data_array.slice(0, 5)

	# 틀린 부분 오른쪽 메인 이미지에 표현하기
	for i in range(currentGameDiffList.size()):
		var diff_idx = currentGameDiffList[i]
		# 선택 된 날짜의 메인 이미지
		var tex_diff : ImageTexture = SingletonMainData.LoadDownloadImage("diff", curDate, diff_idx)
#		# 오른쪽 틀리부분 위치 사이즈 조정
		var tmpImg = right_image.get_child(i) as TextureButton
		var tmpD = currentGameData[diff_idx]
		tmpImg.curDate = curDate
		tmpImg.texture_normal = tex_diff
		tmpImg.position.x = tmpD["x"]
		tmpImg.position.y = tmpD["y"]
		tmpImg.custom_minimum_size.x = tmpD["width"]
		tmpImg.custom_minimum_size.y = tmpD["height"]
		tmpImg.size.x = tmpD["width"]
		tmpImg.size.y = tmpD["height"]
		print(tmpD)
	
	# 카운트 다운 시작	
	game_main_player.play("CountDown")
	
func GameStart():
#	game_main_player.play("CountDown")
	MainMusicDelayPlay()
	
	if tween != null and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(progress_bar.texture_progress_bar, "value", 100, 10)
	tween.tween_callback(TimeOverGameOver)
	return

var gameState = "None"	
func _on_texture_progress_bar_value_changed(value):
	if progress_bar.texture_progress_bar.value > 70 and gameState == "None":
		# 시간이 얼마 남지 않아 긴장 상태의 음악으로 전환
		print("긴장상태 음악")
		gameState = "LAST"
		return
	
# 시간이 끝나 게임 오버
func TimeOverGameOver():
	print("시간되서 게임 오버")
	PreGameOver(gameFail)

func PreGameOver(audioData):
	if tween != null and tween.is_running() == true:
		tween.kill()
	random_music_player.stop()
	
	game_end_sfx_player.stream = audioData
	game_end_sfx_player.play()
	
func GameOver():
	print("게임 오버")

	SingletonMainData.SaveMainData()
	GoMain(1.1)
	
	
func _on_background_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		pass # Replace with function body.


# 이미지 선택 시
func SelectImage(img_type, curDate, gPosition, lPosition):
	print(lPosition)
	
	if curDate == "":
		return
	
	# 충돌 체크
	var checkData = SingletonMainData.mainJsonData["datas"][curDate]["data"]
	var ok_yn = false
	if img_type.find("Diff") >= 0:
		ok_yn = true
	else:
		for j in range(currentGameDiffList.size()):
			var d = checkData[currentGameDiffList[j]]
			var f = ("checked" in d)
			if ("checked" in d) == true and d["checked"] == true:
				continue
			else:
				# 정식 충돌 체크
				if d["x"] <= lPosition.x and (d["x"] + d["width"]) >= lPosition.x and d["y"] <= lPosition.y and (d["y"] + d["height"]) >= lPosition.y:
					ok_yn = true
					checkData[currentGameDiffList[j]]["checked"] = true
					break
		
	if ok_yn == true:	# 틀린부분을 맞춘 경우
		score += 1
		var txr = texture_rect.instantiate()
		txr.texture_normal = circle
		#txr.global_position = gPosition
		txr.global_position = gPosition
		txr.size = Vector2(100, 100)
		get_tree().current_scene.add_child(txr)
	else:			# 잘못 선택한 경우
		print("틀렸음")
		playerLife -= 1
		player_full_heart.size.x -= 15
		var ca01 = crossAct.instantiate()
		ca01.position = lPosition
		left_image.add_child(ca01)
		var ca02 = crossAct.instantiate()
		ca02.position = lPosition
		right_image.add_child(ca02)

		if playerLife == 0:		# 게임 오버(라이프 오버)
			print("라이프 0 게임 오버")
			PreGameOver(gameFail)


	SceneParticles.emit_signal("ParticleEvent", SceneParticles.ParticleName.CLICKHEART, gPosition, 0)
	
	if score == 5:
		PreGameOver(gameSuccess)
		
		SingletonMainData.mainJsonData["datas"][curDate]["Success"] = true

func PreGoMain():
	GoMain(0)

# 메인 화면으로 이동
func GoMain(duration):
	if tween != null and tween.is_running():
		tween.kill()
	
	left_image.disconnect("SelectImage", SelectImage)
	right_image.disconnect("SelectImage", SelectImage)
	options.disconnect("GoMain", GoMain)
	random_music_player.stop()
	SceneTransition.change_scene(SceneTransition.SceneName.SELECTIMAGE, duration)
	

# 메인 음악 딜레이 플레이
func MainMusicDelayPlay():
	random_music_player.stream = backMusicList[randi_range(0, backMusicList.size()-1)]
	random_music_player.play()
	


func _on_random_music_player_finished():
	MainMusicDelayPlay()


