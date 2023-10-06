extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree

var input_vector = Vector2.ZERO
var last_flip_h : bool = false

enum STATE {
	IDLE,
	RUN,
}

var state : STATE = STATE.IDLE : set = setState
func setState(value):
	state = value
	
	if state == STATE.IDLE:
		animation_tree.set("parameters/conditions/is_idle", true)
		animation_tree.set("parameters/conditions/is_run", false)
	elif state == STATE.RUN:
		animation_tree.set("parameters/conditions/is_idle", false)
		animation_tree.set("parameters/conditions/is_run", true)
		
	if input_vector.x > 0:
		last_flip_h = false
	elif input_vector.x < 0:
		last_flip_h = true
		
	sprite_2d.flip_h = last_flip_h

# =========== 케릭저 정보 : Start ==========
var hp = 10;
var speed = 20;
# =========== 케릭저 정보 : End ==========

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	
	key_input()
	
	if input_vector == Vector2.ZERO:
		state = STATE.IDLE
	else:
		state = STATE.RUN
		
	if state == STATE.RUN:
		state_run(delta)
		
	
func state_run(delta):
	velocity = input_vector * speed
	print(input_vector)
	move_and_slide()


func key_input():
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
