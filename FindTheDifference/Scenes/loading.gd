extends Control

###sd
#	JSON으로 데이터를 받아와 정보 등록
###

@export var musicStart : AudioStream
@export var musicEnd : AudioStream

@onready var animation_player = $AnimationPlayer
@onready var timer_main_data = $TimerMainData

@onready var progress_bar = $ProgressBar
@onready var persent_label = $PersentLabel

var arrow = load("res://Art/cursor_pointer3D.png")
var beam = load("res://Art/cursor_pointerFlat_shadow.png")


# 전체 다운로드 해야할 날짜 리스트
var dateList : Array
# 현재 일자를 가져와 다운로드에 활용
var act_date_str : String		
# 현재 처리중인 다운로드
var act_date_index : int = 0

# 현재 다운로드 하고 있는 JSON 데이터
var downloadJsonData : Variant = {		# 내부 데이터는 참고용
	"main_img_url01" : "https://websheet.noligo.co.kr/OIG._cHk4EfL4dH6PeT.bfeQ.jpg",
	"main_img_url02" : "https://websheet.noligo.co.kr/RJi8DqfqoC7agmkaWvJi.jpg",
	"data" : {
		"diff01" : {
			"x" : 100,
			"y" : 100,
			"width" : 50,
			"height" : 50,
		},
		"diff02" : {
			"x" : 100,
			"y" : 100,
			"width" : 50,
			"height" : 50,
		},
		"diff03" : {
			"x" : 100,
			"y" : 100,
			"width" : 50,
			"height" : 50,
		},
		"diff04" : {
			"x" : 100,
			"y" : 100,
			"width" : 50,
			"height" : 50,
		},
		"diff05" : {
			"x" : 100,
			"y" : 100,
			"width" : 50,
			"height" : 50,
		}
	}
}


var tagetDateList = []

# progress bar 속도를 위해 사용
var tween : Tween = null
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)
	
	#SceneAudioPlayer.SceneAudioPlay(SceneAudioPlayer.SceneAudioList.GAMEBONUS, 0)
	animation_player.play("loading")
	progress_bar.texture_progress_bar.value = 0
	var b : bool = SingletonMainData.InitMainData()			# 로컬 스토리지에 메인 데이터 가져오기

	SingletonImageDown.connect("Change_Prograss_Value", Change_Prograss_Value)
	SingletonImageDown.connect("Finsh_Download", Finsh_Download)
	
	timer_main_data.start()
	
# 기정 날짜 리스트 받기
func Get_Date_List(dateList):
	self.dateList = dateList
	#print(self.dateList.size())

	

# 게임 데이터 받기 시작
func _on_timer_main_data_timeout():
	
	# 오늘 기준을 30일치 날짜 가져오기
	var tmpDate = Time.get_datetime_dict_from_system()
	act_date_str = "%04d%02d%02d" % [tmpDate["year"], tmpDate["month"], tmpDate["day"]]
	
	SingletonImageDown.StartDownloadRangeDate(act_date_str, 3)
	

func Change_Prograss_Value(val, rate):
	if tween != null and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(progress_bar.texture_progress_bar, "value", rate, 0.5)

func Finsh_Download():
	if tween != null and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(progress_bar.texture_progress_bar, "value", 100, 0.5)
	tween.tween_callback(GoMainGame)

func GoMainGame():
	if progress_bar.texture_progress_bar.value == 100:
		SingletonMainData.GetAndSortDateList()		# 날짜 리스트 생성 및 정렬
		SingletonImageDown.disconnect("Change_Prograss_Value", Change_Prograss_Value)
		SingletonImageDown.disconnect("Finsh_Download", Finsh_Download)

		animation_player.play("RESET")

		SceneAudioPlayer.SceneAudioPlay(SceneAudioPlayer.SceneAudioList.LEVELPASSED, 0)
		SceneTransition.change_scene(SceneTransition.SceneName.SELECTIMAGE, 1.0)
	

func _on_texture_progress_bar_value_changed(value):
	persent_label.text = str(value) + "%"
