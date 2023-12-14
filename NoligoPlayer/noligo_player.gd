extends Control

@onready var video_stream_player = $VideoStreamPlayer
@onready var file_dialog = $FileDialog


func _ready():
	file_dialog.file_mode = file_dialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.mp4"]
	



func _on_file_dialog_file_selected(path):
	video_stream_player.stream = load(path)  # 선택한 비디오 파일 로드
	video_stream_player.play()              # 비디오 재생 시작


func _on_button_pressed():
	file_dialog.popup_centered_ratio()
