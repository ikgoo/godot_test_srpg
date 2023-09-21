extends Control

@onready var music_volumn_slider = $Panel/VBoxContainer/MusicVolumnSlider
@onready var sfx_volumn_slider = $Panel/VBoxContainer/SFXVolumnSlider

signal  GoMain

@onready var go_main = $Panel/HBoxContainer/GoMain

func _ready():
	music_volumn_slider.value = SingletonMainData.music_default_volumn
	sfx_volumn_slider.value = SingletonMainData.sfx_default_value

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle();

func toggle():
	visible = !visible
	if visible == true:
		var currentSceneName = get_tree().current_scene.name
		if currentSceneName == "MainGame":
			go_main.visible = true
		else:
			go_main.visible = false
		
	get_tree().paused = visible



func _on_go_main_pressed():
	emit_signal("GoMain")
	toggle()


func _on_button_back_pressed():
	toggle()
