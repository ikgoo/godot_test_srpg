extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var gravity = -100
var speed = 100000
var dir = "left"
func _ready() -> void:
	animation_player.play("attck")
func _physics_process(delta: float) -> void:
	if is_on_wall():
		if dir == "left":
			speed = 100000
			dir = "right"
		else:
			speed = -100000
			dir = "left"
	velocity.y -= gravity * delta
	velocity.x = speed * delta
	move_and_slide()



func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	speed = -300


func _on_area_2d_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	speed = 300
