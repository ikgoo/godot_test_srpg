extends CharacterBody2D

@onready var sprite_2d = $Sprite2D

@export var type : String = ""

@export var max_speed : int = 100

func _ready():
	velocity = Vector2.DOWN * max_speed

func _physics_process(delta):
	if velocity.length() > 0:  # 속도가 0이 아닌 경우에만 회전을 적용합니다.
		var angle = velocity.angle()  # 속도 벡터의 각도를 계산합니다.
		rotation = angle  # 스프라이트의 회전을 속도 벡터의 각도로 설정합니다.
		
	move_and_slide()
