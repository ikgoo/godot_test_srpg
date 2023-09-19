extends Node

var lastDate : String

# 게임 전체적인 데이터
var mainJsonData : Variant
# 등록된 날짜 배열
var dateList : Array

# 게임 메인 데이터 위치
var mainDataFilePath = "user://mainJsonData.json"

var userInfo : Variant

# 게임 메인 데이터 가져오기
func InitMainData() -> bool:
	
	var b : bool = false
	if FileAccess.file_exists(mainDataFilePath):
		b = LoadMainData()		# 데이터 불러오기
		
	if b == false or mainJsonData == null:		# 데이터 불러오기 실패(최초이거나 할때)
		# 최초 데이터
		self.lastDate = ""
		self.mainJsonData = {
			"datas" : {}
		}
		self.userInfo = {
			"life" : 5,
		}
		
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
		self.lastDate = tmpMainData['lastDate']
		self.mainJsonData = tmpMainData['mainJsonData']
		self.userInfo = tmpMainData['userInfo']
		mainData.close()
		b = true
	
	return b

# 메인 데이터 저정
func SaveMainData():
	var mainData : FileAccess = FileAccess.open(mainDataFilePath, FileAccess.WRITE)
	mainData.store_var({
		"lastDate" : self.lastDate,
		"mainJsonData" : self.mainJsonData,
		"userInfo" : self.userInfo,
	})
	mainData.close()

func GetAndSortDateList():
	dateList = mainJsonData["datas"].keys()
	dateList.sort()
