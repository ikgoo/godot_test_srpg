extends Node2D

@onready var http_request = $HTTPRequest

var downloadStep = 0
var downloadEndStep = 5

var jsonData : Variant
 
## Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_texture_rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		pass # Replace with function body.




func _on_button_pressed():
	# 메인 json데이터 가져오기
	var mainData : FileAccess = FileAccess.open("user://DiffUserData/mainJsonData.json", FileAccess.READ_WRITE)
	var mainJson : JSON = JSON.new()
	if mainData == null:
		Singleton.mainSeq = 1
		Singleton.mainJsonData = JSON.new()
		# 기본 값 저장 
		var saveData : String = JSON.stringify({
			"mainSeq" : Singleton.mainSeq,
			"mainJsonData" : Singleton.mainJsonData
		})
		mainData.store_string(saveData)
		
	else:
		var error = mainJson.parse(mainData.get_as_text())
		Singleton.mainSeq = mainJson['mainSeq']
		Singleton.mainData = mainJson['mainJsonData']
	

	mainData.close
	
	var tt = []
	tt.append({
		"test" : "test"
	})
	print(tt)
	
#	downloadStep = 0
#	http_request.request("https://websheet.noligo.co.kr/today.php")

#	http_request.download_file = "test.png"
#	http_request.request("https://opengameart.org/sites/default/files/player_19.png")


func _on_http_request_request_completed(result, response_code, headers, body):
	if downloadStep == 0:		# 메인 json다운로드
		jsonData = JSON.parse_string(body.get_string_from_utf8())
		print(jsonData["main_img_url"])
		print(jsonData["data"]["diff01"])

		downloadStep = 1

		http_request.download_file = "test.png"
		http_request.request(jsonData["main_img_url"])
		
	elif downloadStep == 1:		# 메인 이미지 다운로드
		http_request.download_file = "test.png"
		http_request.request(jsonData["main_img_url"])
		
		
		
	
	pass
