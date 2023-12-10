extends CharacterBody2D

@onready var ledge_check_right = $LedgeCheckRight
@onready var ledge_check_left = $LedgeCheckLeft
@onready var animated_sprite_2d = $AnimatedSprite2D


var direction = Vector2.RIGHT
var speed = 25

func _ready():
	animated_sprite_2d.play("Walking")

func _physics_process(delta):
	var found_wall = is_on_wall()
	var found_lege = not ledge_check_right.is_colliding() or not ledge_check_left.is_colliding()
	
	if found_wall or found_lege:
		direction *= -1
	
	if direction.x > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	velocity = direction * speed
	move_and_slide()
