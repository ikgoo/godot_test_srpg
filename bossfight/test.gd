extends CharacterBody2D

@export var initial_speed: float = 500  # 픽셀/초 단위
@export var gravity: float = 980  # 픽셀/초^2 단위


const SPEED = 300.0

func _ready() -> void:
	velocity = Vector2(800, 0)
	var direction = Vector2.RIGHT.rotated(rotation)
	launch(direction, initial_speed)

func launch(direction: Vector2, speed: float):
	velocity = direction * speed
	
	
func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	move_and_slide()
