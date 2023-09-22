extends Node


signal Change_Prograss_Value(val, rate)
signal Finsh_Download()

# 다운로드 처리할 날짜 리스트
var dateList : Array
# 현재 처리중인 날짜의 인덱스
var currentDateIdx : int = 0
# 현재 처리중이 날짜
var currentDate : String = ""

var baseUrl = "https://websheet.noligo.co.kr"

var downloadStep : int = 0
var maxDownloadStep : int = 0
var downloadJsonData : Variant

# 일별 다운로드 스탭 == 1 : JSON / 2 : 메인 이미지 / 3 : 틀린 부분 이미지(배열의 끝까지 반복다운로드)
var downloadSubStep : int = 0
# 틀린 부분 이미지의 현재 다운로드 한 순번
var downloadSubStep3Idx : int = 0

@onready var http_request = $HTTPRequest
@onready var http_request_get_date = $HTTPRequest_GetDate

# 날짜 가져오기
# currentDate : 기준 일자기
# dCount : 기준일자에서 몇일을 가져올건지(30일, -30일)
func StartDownloadRangeDate(currentDate : String, dateCount : int):
	if currentDate == null or currentDate == "":
		var tmpDate = Time.get_datetime_dict_from_system()
		currentDate = "%04d%02d%02d" % [tmpDate["year"], tmpDate["month"], tmpDate["day"]]
		
	if dateCount == null or dateCount == 0:
		dateCount = 1

	#print(baseUrl + "/datelist.php?currentDate=" + currentDate + "&dateCount=" + str(dateCount))
	http_request_get_date.request(baseUrl + "/dateList.php?currentDate=" + currentDate + "&dateCount=" + str(dateCount))

# 받은 날짜 리턴하기
func _on_http_request_get_date_request_completed(result, response_code, headers, body):
	var strData = body.get_string_from_utf8()
	var dataList : Array = JSON.parse_string(strData)
	StartDownload(dataList)
	

# 해당 일자 다운로드
# currentDate : 기준 일자
func StartDownload(tmpDateList : Array) -> bool:
	if tmpDateList == null or tmpDateList.size() == 0:
		var tmpDate = Time.get_datetime_dict_from_system()
		tmpDateList = ["%04d%02d%02d" % [tmpDate["year"], tmpDate["month"], tmpDate["day"]]]		# 오늘 하루만 등록

	# 다운 안받은 대상만 가져옴
	for i in range(tmpDateList.size()):
		#print(tmpDateList[i])
		if ("datas" in SingletonMainData.mainJsonData) == false or (tmpDateList[i] in SingletonMainData.mainJsonData["datas"]) == false:
			self.dateList.append(tmpDateList[i])
	
	if self.dateList.size() == 0:
		emit_signal("Finsh_Download")
		return false
		
	self.currentDateIdx = 0
	self.maxDownloadStep = self.dateList.size()

	StartFistDownload()
	return true

func StartFistDownload():
	downloadSubStep = 1		# 하나의 날짜별 세부스탭 초기화
	downloadSubStep3Idx = 0

	self.currentDate = self.dateList[self.currentDateIdx]
	
	http_request.download_file = ""
	http_request.request(baseUrl + "/today.php?today=" + self.currentDate)
	

# JSON데이터 및 이미지 가져오기
# [downloadSubStep] 일별 다운로드 스탭 == 1 : JSON / 2 : 메인 이미지 / 3 : 틀린 부분 이미지(배열의 끝까지 반복다운로드)
func _on_http_request_request_completed(result, response_code, headers, body):
	if downloadSubStep == 1:		# JSON 파일 다운로드 이후
		# JSON 파일 파싱
		var strData = body.get_string_from_utf8()
		downloadJsonData = JSON.parse_string(strData)
		SingletonMainData.mainJsonData["datas"][self.currentDate] = downloadJsonData[self.currentDate]
		
		# 해당일의 메인 이미지 호출
		downloadSubStep = 2
		CallDownImage("main", -1)
	elif downloadSubStep == 2:
		# 해당일의 틀린 부분 이미지 호출
		downloadSubStep = 3
		CallDownImage("diff", downloadSubStep3Idx)
	else:
		print(downloadSubStep3Idx)
		print(downloadJsonData[currentDate]["data"].size())
		if downloadSubStep3Idx + 1 < downloadJsonData[currentDate]["data"].size():
			downloadSubStep3Idx += 1
			CallDownImage("diff", downloadSubStep3Idx)
		else:
			if currentDateIdx == maxDownloadStep-1:
				emit_signal("Change_Prograss_Value", currentDateIdx+1, 100)
				emit_signal("Finsh_Download")
				# lastDate 저장
				SingletonMainData.SaveMainData()
			else:
				currentDateIdx += 1
				#print(self.dateList[self.currentDateIdx])
				print((currentDateIdx * 1.0)/maxDownloadStep * 100)
				emit_signal("Change_Prograss_Value", currentDateIdx, int((currentDateIdx * 1.0)/maxDownloadStep * 100))
				StartFistDownload()
				

# dlalwl ekdnsfhem
func CallDownImage(type : String, idx : int):
	var tmpUrl : String = ""
	var last_three : String = ""
	var tmpFileName : String = ""
	if type == "main":
		tmpUrl = str(downloadJsonData[currentDate][type + "_img_url"])
		last_three = tmpUrl.right(3)
		tmpFileName = "user://" + type + "_" + currentDate + "." + last_three
	else:
		tmpUrl = str(downloadJsonData[currentDate]["data"][idx][type + "_img_url"])
		last_three = tmpUrl.right(3)
		tmpFileName = "user://" + type + "_" + currentDate + "_0" + str(idx) + "." + last_three
	
	http_request.download_file = tmpFileName
	http_request.request(baseUrl + tmpUrl)		# 메인 이미지 호출
	
