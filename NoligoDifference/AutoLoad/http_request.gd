extends Node


signal Change_Prograss_Value(val, rate)
signal Finsh_Download()

# 다운로드 처리할 날짜 리스트
var dateList : Array
# 현재 처리중인 날짜의 인덱스
var currentDataIdx : int = 0
# 현재 처리중이 Mst Id
var currentData : int = 0

var baseUrl = "https://difference.noligo.co.kr"

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
# currentData : mst id
# dCount : 기준일자에서 몇일을 가져올건지(30일, -30일)
func StartDownloadRangeDate(dataCount : int):
	if currentData == 0:
		currentData = 1
		
	if dataCount == null or dataCount == 0:
		dataCount = 1

	print(Global.last_mst_id - Global.clear_mst_id)
	if Global.last_mst_id - Global.clear_mst_id  >= dataCount:
		# 남아있는 틀린그림 수가 다운 받으려는 수보다 크거나 같으면 추가로 다운 받지 않음
		DownloadEnd()
		return
		
	print(dataCount - (Global.last_mst_id - Global.clear_mst_id))
	if dataCount - (Global.last_mst_id - Global.clear_mst_id)  <= dataCount:
		# 남아있는 수를 빼고 dataCount를 맞춰서 다운로드 하도록 수를 조정
		dataCount = dataCount - (Global.last_mst_id - Global.clear_mst_id)
	
	var base_uri = baseUrl + "/api/getMstIDs/" + str(Global.last_mst_id+1) + "/" + str(dataCount)
	
	http_request_get_date.request(base_uri, [], HTTPClient.METHOD_GET, "")

# 받은 날짜 리턴하기
func _on_http_request_get_date_request_completed(result, response_code, headers, body):
	var strData = body.get_string_from_utf8()
	var dataList : Array = JSON.parse_string(strData)
	if dataList.size() > 0:
		StartDownload(dataList)
	else:
		DownloadEnd()
	

# 해당 일자 다운로드
# currentDate : 기준 일자
func StartDownload(tmpDateList : Array) -> bool:
	if tmpDateList == null or tmpDateList.size() == 0:
		var tmpDate = Time.get_datetime_dict_from_system()
		tmpDateList = ["%04d%02d%02d" % [tmpDate["year"], tmpDate["month"], tmpDate["day"]]]		# 오늘 하루만 등록

	# 다운 안받은 대상만 가져옴
	for i in range(tmpDateList.size()):
		#print(tmpDateList[i])
		if ("datas" in Global.mainJsonData) == false or (tmpDateList[i] in Global.mainJsonData["datas"]) == false:
			self.dateList.append(tmpDateList[i])
	
	if self.dateList.size() == 0:
		emit_signal("Finsh_Download")
		return false
		
	self.currentDataIdx = 0
	self.maxDownloadStep = self.dateList.size()

	StartFistDownload()
	return true

func StartFistDownload():
	downloadSubStep = 1		# 하나의 날짜별 세부스탭 초기화
	downloadSubStep3Idx = 0

	self.currentData = int(self.dateList[self.currentDataIdx])
	
	http_request.download_file = ""
	var u = baseUrl + "/api/getData/" + str(self.currentData)
	print(u)
	http_request.request(u)
	

# JSON데이터 및 이미지 가져오기
# [downloadSubStep] 일별 다운로드 스탭 == 1 : JSON / 2 : 메인 이미지 / 3 : 틀린 부분 이미지(배열의 끝까지 반복다운로드)
func _on_http_request_request_completed(result, response_code, headers, body):
	if downloadSubStep == 1:		# JSON 파일 다운로드 이후
		# JSON 파일 파싱
		var strData = body.get_string_from_utf8()
		downloadJsonData = JSON.parse_string(strData)
		Global.mainJsonData["datas"][self.currentData] = downloadJsonData[0]
		Global.last_mst_id = downloadJsonData[0]["id"]
		
		# 해당일의 메인 이미지 호출
		downloadSubStep = 2
		CallDownImage("main", -1)
	elif downloadSubStep == 2:
		# 해당일의 틀린 부분 이미지 호출
		downloadSubStep = 3
		CallDownImage("diff", downloadSubStep3Idx)
	else:
		print(downloadSubStep3Idx)
		print(downloadJsonData[0]["difference_dtl"].size())
		if downloadSubStep3Idx + 1 < downloadJsonData[0]["difference_dtl"].size():
			downloadSubStep3Idx += 1
			CallDownImage("diff", downloadSubStep3Idx)
		else:
			if currentDataIdx == maxDownloadStep-1:
				DownloadEnd()
			else:
				currentDataIdx += 1
				#print(self.dateList[self.currentDataIdx])
				print((currentDataIdx * 1.0)/maxDownloadStep * 100)
				emit_signal("Change_Prograss_Value", currentDataIdx, int((currentDataIdx * 1.0)/maxDownloadStep * 100))
				StartFistDownload()
				

func DownloadEnd():
	emit_signal("Change_Prograss_Value", 100, 100)
	emit_signal("Finsh_Download")
	# lastDate 저장
	Global.SaveMainData()

# dlalwl ekdnsfhem
func CallDownImage(type : String, idx : int):
	var tmpUrl : String = ""
	var last_three : String = ""
	var tmpFileName : String = ""
	if type == "main":
		tmpUrl = str(downloadJsonData[0]["main_img_url"])
		last_three = tmpUrl.right(3)
		tmpFileName = "user://" + type + "_" + str(currentData) + "." + last_three
	else:
		tmpUrl = str(downloadJsonData[0]["difference_dtl"][idx]["diff_img_url"])
		last_three = tmpUrl.right(3)
		tmpFileName = "user://" + type + "_" + str(currentData) + "_0" + str(idx) + "." + last_three
	
	http_request.download_file = tmpFileName
	var u = baseUrl + "/" + tmpUrl
	print(u)
	http_request.request(u)		# 메인 이미지 호출
	
