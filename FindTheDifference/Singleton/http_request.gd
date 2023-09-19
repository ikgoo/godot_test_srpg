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

var downloadSubStep : int = 0
var downloadMaxSubStep : int = 6

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

	self.currentDate = self.dateList[self.currentDateIdx]
	
	http_request.download_file = ""
	http_request.request(baseUrl + "/today.php?today=" + self.currentDate)
	

# JSON데이터 및 이미지 가져오기
func _on_http_request_request_completed(result, response_code, headers, body):
	if downloadSubStep == 1:
		var strData = body.get_string_from_utf8()
		downloadJsonData = JSON.parse_string(strData)
		SingletonMainData.mainJsonData["datas"][self.currentDate] = downloadJsonData[self.currentDate]
		
		
		# 해당일의 메인 이미지 호출
		downloadSubStep = 2
		var last_three = str(downloadJsonData[currentDate]["main_img_url"]).right(3)
		http_request.download_file = "user://main_" + currentDate + "." + last_three
		#print(baseUrl + downloadJsonData[procDate]["main_img_url"])
		http_request.request(baseUrl + downloadJsonData[currentDate]["main_img_url"])		# 메인 이미지 호출
	elif downloadSubStep >= 2:
		if downloadSubStep <= downloadMaxSubStep:
			downloadSubStep += 1
			var img_cnt : String = "0" + str(downloadSubStep-2)
			var last_three = str(downloadJsonData[currentDate]["data"]["diff" + img_cnt]["diff_img_url"]).right(3)
			http_request.download_file = "user://sub_" + currentDate + "_" + img_cnt + "." + last_three
			#print(baseUrl + downloadJsonData[currentDate]["data"]["diff" + img_cnt]["diff_img_url"])
			http_request.request(baseUrl + downloadJsonData[currentDate]["data"]["diff" + img_cnt]["diff_img_url"])		# 메인 이미지 호출
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
				

