extends Marker2D

const RANDOM_ANGLE = PI / 2.0

@export var bullet_scene = preload("res://Bullet/bullet_with_server.tscn")
var fire_rate = 600.0
var cnt = 0
func _process(delta) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var bullet_count = round(fire_rate * delta)
		for index in bullet_count:
			var bullet = bullet_scene.instantiate()
#			bullet.fire(get_parent().global_transform)
			get_parent().add_child(bullet)
			cnt += 1
			print(cnt)
