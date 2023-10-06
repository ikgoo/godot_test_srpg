extends CanvasLayer


# 옵션 관련 정보
@export var optionData : OptionData


func _ready():
	LoadData()

	# 테스트 용 
#
	optionData.audio_master = 0.2
	SaveData()
#	pass

	

# 저장 관련된 리소스 모두 파일로 저장 처리
func SaveData():
	ResourceSaver.save(optionData, "user://OptionData.tres")


# 저장 관련된 리소스 모두 파일에에서 불러옴
func LoadData():
	var tttt = ResourceLoader.exists("user://OptionData.tres")
	if ResourceLoader.exists("user://OptionData.tres") == true:
		optionData = ResourceLoader.load("user://OptionData.tres")
		optionData.init()
	else:
		optionData = OptionData.new()
