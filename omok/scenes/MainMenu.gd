extends Control

var is_dev = true

@onready var black_rall = $NinePatchRect/BlackRall
@onready var white_rall = $NinePatchRect/WhiteRall
@onready var animation_player = $AnimationPlayer
@onready var animation_menu_move = $NinePatchRect/MidArea/MenuArea/AnimationMenuMove

@onready var music_h_slider = $NinePatchRect/MidArea/MenuArea/MoveArea/Option/Music/MusicHSlider
@onready var sfxh_slider = $NinePatchRect/MidArea/MenuArea/MoveArea/Option/SFX/SFXHSlider
@onready var option_button = $NinePatchRect/MidArea/MenuArea/MoveArea/Option/HBoxContainer2/OptionButton

@onready var text_edit = $NinePatchRect/TextEdit

var session : NakamaSession
func _ready():
	if is_dev:
		text_edit.show()
	else:
		text_edit.hide()
		
	text_edit.text = 'omoks_' + str(OS.get_process_id())

	
	for i in len(OptionData.languageName):
		option_button.add_item(OptionData.languageName[i])
		
	music_h_slider.value = OptionData.audio_music
	sfxh_slider.value =  OptionData.audio_sfx
	option_button.select(OptionData.language)
	

	OptionData.connect("change_audio_music", change_audio_music)
	OptionData.connect("change_audio_sfx", change_audio_sfx)
	


func _process(delta):
	pass

func change_audio_music(audio_music):
	music_h_slider.value = audio_music
	
func change_audio_sfx(audio_sfx):
	sfxh_slider.value = audio_sfx

func PlayMainMenu(playNmae):
	animation_player.play(playNmae)




func _on_option_pressed():		# 옵션 선택 시
	animation_menu_move.play("ToOption")



func _on_back_pressed():		# 메인 메뉴로 이동
	animation_menu_move.play("ToMain")



func _on_music_h_slider_value_changed(value):
	OptionData.audio_music = value

func _on_music_h_slider_drag_ended(value_changed):
	OptionData.SaveData()


func _on_sfxh_slider_value_changed(value):
	OptionData.audio_sfx = value

func _on_sfxh_slider_drag_ended(value_changed):
	OptionData.SaveData()




func _on_option_button_item_selected(index):
	OptionData.language = index
	TranslationServer.set_locale(OptionData.languageCode[index])
	OptionData.SaveData()
	

func _on_login_pressed():
	print(text_edit.text)
	if session == null:
		session = await Online.nakama_client.authenticate_device_async(text_edit.text, text_edit.text, true, { "test": "test" } )
		if session.is_exception():
			print(session.get_exception().message)
			return false
		print(session)
		Online.nakama_session = session
		text_edit.hide()
		$NinePatchRect/Login.hide()
	
	return true


func _on_online_pressed():
	var tt = await _on_login_pressed()
	
	if tt == false:
		print('오류')
		return 
		
	$NinePatchRect/Matching.show()
	if not Online.is_nakama_socket_connected():
		Online.connect_nakama_socket()
		await Online.socket_connected

	print("looking for a Match....")
	
	var data = {
		min_count = 2,
		max_count = 2,
	}
	OnlineMatch.start_matchmaking(Online.nakama_socket, data)

