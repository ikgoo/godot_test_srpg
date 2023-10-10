extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree
@onready var attack_point = $AttackPoint
@onready var hurt_effect = $HurtEffect
@onready var hurt_box = $HurtBox

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
var speed = 40;
var damege = 2;
# =========== 케릭저 정보 : End ==========

#@onready var slash = $Slash
@onready var slash = $Attacks/Slash

func _ready():
	animation_tree.active = true
	
#	slash.init(self)
	

func _physics_process(delta):
	
	key_input()
	
	if input_vector == Vector2.ZERO:
		state = STATE.IDLE
	else:
		state = STATE.RUN
		
	if state == STATE.RUN:
		state_run(delta)
		
func _process(delta):
	if check_hurt():
		GameManager.Demage(0.1)
	
func state_run(delta):
	velocity = input_vector * speed
	move_and_slide()


func key_input():
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	


func _on_hurt_box_area_entered(area):
	pass


func _on_hurt_box_area_exited(area):
	pass

func check_hurt() -> bool:
	print(hurt_effect.is_playing())
	if hurt_effect.current_animation == "Hurt" and hurt_box.get_overlapping_areas().size() == 0:
		hurt_effect.play("RESET")
	elif hurt_effect.is_playing() == false and hurt_box.get_overlapping_areas().size() != 0:
		hurt_effect.play("Hurt")
		
	if hurt_effect.current_animation == "Hurt":
		return true
	else:
		return false