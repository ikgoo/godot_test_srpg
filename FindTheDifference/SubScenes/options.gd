extends Control

@onready var music_volumn_slider = $Panel/VBoxContainer/MusicVolumnSlider
@onready var sfx_volumn_slider = $Panel/VBoxContainer/SFXVolumnSlider




func _ready():
	music_volumn_slider.value = SingletonMainData.music_default_volumn
	sfx_volumn_slider.value = SingletonMainData.sfx_default_value

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle();

func toggle():
	visible = !visible
	get_tree().paused = visible


func _on_button_back_pressed():
	toggle()