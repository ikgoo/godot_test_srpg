extends Node

var last_mst_id : int
var clear_mst_id : int = 0

# 게임 전체적인 데이터
var mainJsonData : Variant
# 등록된 날짜 배열
var dateList : Array

# 게임 메인 데이터 위치
var mainDataFilePath = "user://mainJsonData.json"

# 유저 정보
var userInfo : Variant = {
	"left" : 5,			# 생명
	"help" : 5,			# 도움
}

# 음향 기본값
var music_default_volumn = 0.2
var sfx_default_value = 0.1

# 메인 게임에 사용될 날짜
var sctDate = ""

# 개발 여부
var isDev = true

func _ready() -> void:
	var bus_index1 = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index1, linear_to_db(music_default_volumn))
	var bus_index2 = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index2, linear_to_db(music_default_volumn))

# 게임 메인 데이터 가져오기
func InitMainData() -> bool:
	
	var b : bool = false
	if FileAccess.file_exists(mainDataFilePath):
		b = LoadMainData()		# 데이터 불러오기
		
	if b == false or mainJsonData == null:		# 데이터 불러오기 실패(최초이거나 할때)
		# 최초 데이터
		self.last_mst_id = 0
		self.mainJsonData = {
			"datas" : {}
		}
		self.userInfo = {
			"life" : 5,
		}
		self.music_default_volumn = 0.2
		self.sfx_default_value = 0.1
		
		SaveMainData()
		b = true
		
	
	return b

# 메인 데이터 불러오기
func LoadMainData() -> bool:
	var b : bool = true
	
	var mainData : FileAccess = FileAccess.open(mainDataFilePath, FileAccess.READ)
	
	if mainData == null:
		b = false
	else:
		var tmpMainData : Variant = mainData.get_var()
		self.last_mst_id = tmpMainData['last_mst_id']
		self.clear_mst_id = tmpMainData['clear_mst_id']
		self.mainJsonData = tmpMainData['mainJsonData']
		if tmpMainData['userInfo'] != null:
			self.userInfo = tmpMainData['userInfo']
			
		if tmpMainData.has('music_default_volumn'):
			self.music_default_volumn = tmpMainData['music_default_volumn']
		if tmpMainData.has('sfx_default_value'):
			self.sfx_default_value = tmpMainData['sfx_default_value']
			
		mainData.close()
		b = true
	
	return b

# 메인 데이터 저정
func SaveMainData():
	var mainData : FileAccess = FileAccess.open(mainDataFilePath, FileAccess.WRITE)
	mainData.store_var({
		"last_mst_id" : self.last_mst_id,
		"clear_mst_id" : self.clear_mst_id, 
		"mainJsonData" : self.mainJsonData,
		"userInfo" : self.userInfo,
		"music_default_volumn" : self.music_default_volumn,
		"sfx_default_value" : self.sfx_default_value,
	})
	mainData.close()

func GetAndSortDateList():
	dateList = mainJsonData["datas"].keys()
	dateList.sort()


# 다운받은 이미지 불러오기(ImageTexture 로)
# type : main, diff
func LoadDownloadImage(type : String, curDate : int, idx : int) -> ImageTexture:
	var path = ""
	if type == "main":
		path = "user://" + type + "_" + str(curDate) + ".jpg"
	else:
		path = "user://" + type + "_" + str(curDate) + "_0" + str(idx) + ".jpg"

	var img = Image.new()
	var tex = ImageTexture.new()
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	var img_buffer = file.get_buffer(file.get_length())
	
	match path.get_extension():
		"png":
			img.load_png_from_buffer(img_buffer)
		"jpg":
			img.load_jpg_from_buffer(img_buffer)

	tex.set_image(img)
	file.close()
	
	
	
	return tex
