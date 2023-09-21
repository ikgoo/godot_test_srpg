extends Control

@export var backMusicList : Array[AudioStream]

@onready var random_music_player = $RandomMusicPlayer

@onready var left_image = $LeftImage
@onready var right_image = $RightImage

@onready var texture_rect = preload("res://SubScenes/texture_rect.tscn")

@onready var circle = preload("res://Art/circle.jpg")

# 맞춘수
var score : int = 0

func _ready():
	randomize()
	random_music_player.stream = backMusicList[randi_range(0, backMusicList.size()-1)]
	random_music_player.play()
	
	# 최초에 맞춘내용 초기화 필요
	
	var curDate = SingletonMainData.sctDate
	# 선택 된 날짜의 메인 이미지
	for i in range(1, 3):
		var tex : ImageTexture = SingletonMainData.LoadDownloadImage(curDate, i)
		
		var d = SingletonMainData.mainJsonData["datas"][curDate]["data"]
		if i == 1:
			left_image.texture = tex
			left_image.curData = d
			left_image.curDate = curDate
			left_image.img_type = "background"
			left_image.connect("SelectImage", SelectImage)
			
			if SingletonMainData.isDev == true:
				# 왼쪽 틀리부분 위치 사이즈 조정
				for j in range(1, 6):
					var tmpImg = left_image.get_child(j-1)
					var tmpD = d["diff0" + str(j)]
					tmpImg.position.x = tmpD["x"]
					tmpImg.position.y = tmpD["y"]
					tmpImg.size.x = tmpD["width"]
					tmpImg.size.y = tmpD["height"]
					print(tmpD)
				
		else:
			right_image.texture = tex
			right_image.curData = SingletonMainData.mainJsonData["datas"][curDate]["data"]
			right_image.curDate = curDate
			right_image.img_type = "background"
			right_image.connect("SelectImage", SelectImage)
			
			if SingletonMainData.isDev == true:
				# 오른쪽 틀리부분 위치 사이즈 조정
				for j in range(1, 6):
					var tmpImg = right_image.get_child(j-1)
					var tmpD = d["diff0" + str(j)]
					tmpImg.position.x = tmpD["x"]
					tmpImg.position.y = tmpD["y"]
					tmpImg.size.x = tmpD["width"]
					tmpImg.size.y = tmpD["height"]
					print(tmpD)
	


func _on_background_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		pass # Replace with function body.


# 이미지 선택 시
func SelectImage(img_type, curDate, gPosition, lPosition, event):
	print(lPosition)
	
	# 충돌 체크
	var checkData = SingletonMainData.mainJsonData["datas"][curDate]["data"]
	var ok_yn = false
	for i in range(1, 6):
		var d = checkData["diff0" + str(i)]
		var f = ("checked" in d)
		if ("checked" in d) == true:
			continue
		else:
			# 정식 충돌 체크
			if d["x"] <= lPosition.x and (d["x"] + d["width"]) >= lPosition.x and d["y"] <= lPosition.y and (d["y"] + d["height"]) >= lPosition.y:
				ok_yn = true
				score += 1
				checkData["diff0" + str(i)]["checked"] = true
				break
	print(ok_yn)
	
	if ok_yn == true:
		var txr = texture_rect.instantiate()
		txr.texture = circle
		#txr.global_position = gPosition
		txr.global_position = gPosition
		txr.size = Vector2(100, 100)
		get_tree().current_scene.add_child(txr)

	SceneParticles.emit_signal("ParticleEvent", SceneParticles.ParticleName.CLICKHEART, gPosition, 0)
	
	if score == 5:
		random_music_player.stop()
		SceneAudioPlayer.SceneAudioPlay(SceneAudioPlayer.SceneAudioList.CLICK, 0)
		SceneTransition.change_scene(SceneTransition.SceneName.SELECTIMAGE, 1.1)
