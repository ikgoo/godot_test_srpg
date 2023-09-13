extends AnimatedSprite2D

func _ready():
	connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	play("Animate")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
