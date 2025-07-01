@tool
extends Node2D
@onready var animation_player: AnimationPlayer = $Line2D/AnimationPlayer
@onready var line_2d_2: Line2D = $Line2D2
@onready var ray_cast_2d = $RayCast2D
@onready var timer : Timer = $Timer
@onready var line_2d = $Line2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@export var m_name : String = ""
@export var id : int
@onready var c_attack_m: Area2D = $c_attack_m
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@export_range(100, 500) var range_max : float = 280:
	set(value):
		range_max = value
		update_collision_shape()

const NEW_CIRCLE_SHAPE_2D = preload("res://new_circle_shape_2d.tres")
var hp = 30
var on_screen = false
var attack = false
var player
var reload = false
var reload_d = false
var p = null
# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape_2d.shape = NEW_CIRCLE_SHAPE_2D.duplicate(true)
	update_collision_shape()
	if not Engine.is_editor_hint():
		player = get_parent().get_parent().find_child("player")

func update_collision_shape():
	if collision_shape_2d and collision_shape_2d.shape:
		collision_shape_2d.shape.radius = range_max

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hp <= 0:
		p.paring_j_go = false
		p.paring_ok = false
		queue_free()
	if on_screen == true:
		line_2d.points[1] = to_local(player.position)
		ray_cast_2d.target_position = to_local(player.position)
		line_2d_2.points[0] = line_2d.points[0]
		line_2d_2.points[1] = line_2d.points[1]
		if attack == true and timer.is_stopped() and reload == false:
			animation_player.play("attack")
			timer.start()
			line_2d.visible = true
			line_2d_2.visible = true
			audio_stream_player_2d.play()
			
			
		elif reload == true  and timer.is_stopped() and reload_d == false:
			timer.start()
			line_2d.visible = false
			line_2d_2.visible = false
			reload_d = true
		if attack == false:
			timer.stop()
			line_2d.visible = false
			line_2d_2.visible = false
			reload = false
			reload_d = false
			audio_stream_player_2d.stop()

func hurt(dam):
	hp -= dam
func _on_area_2d_area_entered(area):
	attack = true
	player.get_mobs(self)

func _on_area_2d_area_exited(area):
	attack = false
	player.delete_mobs(self)


func _on_timer_timeout():
	if reload == false:
		player.mob_attack(20,self,false)
		reload = true
		audio_stream_player_2d.stop()
	elif reload == true:
		reload = false
		reload_d = false
	timer.stop()


func _on_visible_on_screen_notifier_2d_screen_entered():
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen = false


func _on_c_attack_m_area_entered(area: Area2D) -> void:
	p = area.get_parent()
	area.get_parent().paring_ok = true
	sprite_2d_2.visible = true


func _on_c_attack_m_area_exited(area: Area2D) -> void:
	sprite_2d_2.visible = false
	area.get_parent().paring_ok = false
