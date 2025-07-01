extends Node2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var camera: Camera2D
var shake_amount: float = 0.0
var shake_duration: float = 0.0
var shake_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.play()
	camera = $Camera2D
	shake_timer = $shake_timer

func shake_camera2():
	shake_camera(20, 0.3)
	
# 카메라 흔들림 함수
func shake_camera(amount: float, duration: float) -> void:
	shake_amount = amount
	shake_duration = duration
	shake_timer.start(0.05)  # 0.05초마다 흔들림 적용
	_apply_camera_shake()

# 카메라 흔들림 적용 함수
func _apply_camera_shake() -> void:
	if shake_duration > 0:
		var shake_offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		camera.offset = shake_offset
		shake_duration -= 0.05  # 흔들림 지속 시간 감소
	else:
		camera.offset = Vector2.ZERO
		shake_timer.stop()  # 타이머 정지

# 타이머 타임아웃 시 호출되는 함수
func _on_shake_timer_timeout() -> void:
	_apply_camera_shake()
