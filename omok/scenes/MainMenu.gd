extends Control

@onready var black_rall = $NinePatchRect/BlackRall
@onready var white_rall = $NinePatchRect/WhiteRall
@onready var animation_player = $AnimationPlayer
@onready var animation_menu_move = $NinePatchRect/MidArea/MenuArea/AnimationMenuMove

@onready var music_h_slider = $NinePatchRect/MidArea/MenuArea/MoveArea/Option/Music/MusicHSlider
@onready var sfxh_slider = $NinePatchRect/MidArea/MenuArea/MoveArea/Option/SFX/SFXHSlider
@onready var option_button = $NinePatchRect/MidArea/MenuArea/MoveArea/Option/HBoxContainer2/OptionButton


func _ready():
	for i in len(OptionData.languageName):
		option_button.add_item(OptionData.languageName[i])
		
	music_h_slider.value = OptionData.audio_music
	sfxh_slider.value =  OptionData.audio_sfx
	option_button.select(OptionData.language)
	

	OptionData.connect("change_audio_music", change_audio_music)
	OptionData.connect("change_audio_sfx", change_audio_sfx)

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
	
