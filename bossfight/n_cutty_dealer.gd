extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var l_turn = 0
var r_turn = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var c_attack_m: Area2D = $c_attack_m
@onready var collision_shape_2d: CollisionShape2D = $c_attack_m/CollisionShape2D
var speed = 60000.0
const JUMP_VELOCITY = -400.0
var hp = 10
var go = true
var p = null
func _ready() -> void:
	animation_player.play("attck")

	

func _process(delta: float) -> void:
	if hp <= 0:
		p.paring_j_go = false
		p.paring_ok = false
		queue_free()
	velocity.x = speed * delta
	if not is_on_floor():
		velocity += get_gravity() * delta
	if go:
		move_and_slide()

func hurt(dam):
	hp -= dam
func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	speed = 60000
	animated_sprite_2d.flip_h = true

func _on_area_2d_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	speed = -60000
	animated_sprite_2d.flip_h = false
func _on_area_2d_3_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	l_turn -= 1
	if l_turn == 0:
		speed = -60000
		animated_sprite_2d.flip_h = false

func _on_area_2d_4_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	r_turn -= 1
	if r_turn == 0:
		speed = 60000
		animated_sprite_2d.flip_h = true
func _on_area_2d_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	l_turn += 1


func _on_area_2d_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	r_turn += 1


func _on_area_2d_5_area_entered(area: Area2D) -> void:
	go = true
	p = area.get_parent()
	area.get_parent().get_mobs(self)
	area.get_parent().mob_attack(20,self,false)


func _on_c_attack_m_area_entered(area: Area2D) -> void:
	sprite_2d.visible = true
	area.get_parent().paring_ok = true
	area.get_parent().get_mobs(self)


func _on_c_attack_m_area_exited(area: Area2D) -> void:
	sprite_2d.visible = false
	area.get_parent().paring_ok = false
	area.get_parent().delete_mobs(self)


func _on_attack_area_exited(area: Area2D) -> void:
	go = false
