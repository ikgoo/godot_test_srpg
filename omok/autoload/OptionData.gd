extends Node2D

class_name Option


var languageName = ["ENGLISH", "KOREA"]
var languageCode = ["en", "kr"]

# 음향을 관리하는 클래스
# 음향 처리를 위해서 오디오 설정이 필요
# Music, SFX를 추가하여야 됨
# 음향 Range는 0~1이고 Step는 0.1정도면 됨

signal change_audio_master(audio_master)
signal change_audio_music(audio_music)
signal change_audio_sfx(audio_sfx)

# 초기화가 됐는지 확인
var isRady = false

# 음향 마스터
@export var audio_master : float = 1.0 : set = SetAudioMaster
func SetAudioMaster(value):
	audio_master = value
	var bus_idx = AudioServer.get_bus_index("Master")
	if  bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(audio_master))
		
	if isRady:
		emit_signal("change_audio_master", SetAudioMaster)
	
# 메인 음향
@export var audio_music : float = 1.0 : set = SetAudioMusic
func SetAudioMusic(value):
	audio_music = value
	print(audio_music)
	var bus_idx = AudioServer.get_bus_index("Music")
	if  bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(audio_master))
		
	if isRady:
		emit_signal("change_audio_music", SetAudioMusic)

# 효과음
@export var audio_sfx : float = 1.0 : set = SetAudioSFX
func SetAudioSFX(value):
	audio_sfx = value
	var bus_idx = AudioServer.get_bus_index("SFX")
	if  bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(audio_master))
	
	if isRady:
		emit_signal("change_audio_sfx", audio_sfx)

var language: int = 0

# 데이터를 저장
func SaveData():
	var optionData2: OptionResourceData = OptionResourceData.new()
	optionData2.audio_master = audio_master
	optionData2.audio_music = audio_music
	optionData2.audio_sfx = audio_sfx
	optionData2.language = language
	
	var err = ResourceSaver.save(optionData2, "user://OptionData.tres", ResourceSaver.FLAG_COMPRESS)
	pass
	
# 데이터를 로드
func LoadData():
	if ResourceLoader.exists("user://OptionData.tres") == true:
		var optionData: OptionResourceData = ResourceLoader.load("user://OptionData.tres")
		audio_master = optionData.audio_master
		audio_music = optionData.audio_music
		audio_sfx = optionData.audio_sfx
		language = optionData.language
	else:
		audio_master = 0.8
		audio_music = 0.8
		audio_sfx = 0.8
		language = 0
		
	TranslationServer.set_locale(languageCode[language])
		
# 초기화
func init():
	isRady = true

func _ready():
	LoadData()
