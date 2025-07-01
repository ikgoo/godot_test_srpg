extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var par = false  # 발사 여부를 나타내는 변수
var died = false
var direction : Vector2
var speed = 4000
var initial_velocity: Vector2
var gravity: float = 7000
var start_position: Vector2

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	if not died and par:
		launch(Vector2.RIGHT.rotated(rotation), speed)
		par = false

func _physics_process(delta: float) -> void:
	if not died and not par:
		velocity.y += gravity * delta
		move_and_slide()
		
		# 포물선 움직임에 따른 회전 계산
		var angle = atan2(velocity.y, velocity.x)
		rotation = angle

func launch(direction: Vector2, speed: float):
	initial_velocity = direction * speed
	velocity = initial_velocity
	start_position = position
	# 초기 회전 설정
	rotation = direction.angle()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if died == false:
		GameManage.hp -= 10
		animation_player.play("attack")
		died = true
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if died == false:
		animation_player.play("attack")
		died = true


func _on_area_2d_3_area_entered(area: Area2D) -> void:

	area.get_parent().hp -= 10
	area.get_parent().set_health_go()
	animation_player.play("attack")
	died = true
