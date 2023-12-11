@tool
extends Path2D

@onready var animation_player = $PathFollow2D/Enemy/AnimationPlayer

enum ANIMATION_TYPE {
	LOOP,
	BOUNCE
}
@export var animation_type : ANIMATION_TYPE = ANIMATION_TYPE.LOOP : set = _set_animation_type
func _set_animation_type(val):
	animation_type = val
	if animation_player != null:
		play_updated_animation()
@export var speed : int = 1 : set = _set_speed
func _set_speed(val):
	speed = val
	if animation_player != null:
		animation_player.speed_scale = speed

func _ready():
	play_updated_animation()
	
func play_updated_animation():
	match animation_type:
		ANIMATION_TYPE.LOOP: animation_player.play("MoveAlongPathLoop")
		ANIMATION_TYPE.BOUNCE: animation_player.play("MoveAlongPathBounce")
		
	animation_player.speed_scale = speed
	
