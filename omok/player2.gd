extends CharacterBody2D

@export var playerControlled : bool = false

@export var bullet: PackedScene

var lookAtVector = 0
var speed: int = 3000

func _ready():
	pass
	
	
func _physics_process(delta):
	if playerControlled:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed * delta
		move_and_slide()
		look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("shoot"):
			shoot($Marker2D.global_position, name)


func shoot(shootpos, playerWhoShot):
	var bullet = bullet.instantiate()
	get_tree().get_nodes_in_group("GameWorld")[0]
