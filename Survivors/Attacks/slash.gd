extends Node2D

class_name calss_attack

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer

var player : CharacterBody2D

func init(player : CharacterBody2D) -> void:
	self.player = player
	timer.start()



func _on_timer_timeout():
	var player_sprite : Sprite2D = player.get_node("Sprite2D") as Sprite2D
	if player_sprite.flip_h == false:
		scale.x = 1
	else:
		scale.x = -1
		
#	sprite_2d.flip_h = player_sprite.flip_h
	animation_player.play("Attack")
		

func attack_end():
	timer.start()


func _on_hit_box_area_entered(area):
	area.get_parent().queue_free()
