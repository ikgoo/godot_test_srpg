extends CharacterBody2D

@export var playerControlled : bool = false

@export var Bullet: PackedScene

signal PlayerHasDied

var lookAtVector = 0
var speed: int = 3000

func _get_custom_rpc_methods():
	return [
		"UpdateRemotePlayers",
		"Die",
	]

func _ready():
	pass
	
	
func _physics_process(delta):
	if playerControlled:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed * delta
		move_and_slide()
		look_at(get_global_mouse_position())
		
		var shooting = false
		if Input.is_action_just_pressed("shoot"):
			shoot($Marker2D.global_transform, name)
			shooting = true
			
		OnlineMatch.custom_rpc(self, "UpdateRemotePlayers", [global_position, rotation, shooting, $Marker2D.global_transform, name])


func shoot(shootpos, playerWhoShot):
	var bullet = Bullet.instantiate()
	var gameWorld = get_tree().get_nodes_in_group("GameWorld")
	gameWorld[0].add_child(bullet)
	bullet.global_transform = shootpos
	
func UpdateRemotePlayers(currentPosition, currentRotation, shooting, shootPos, playerWhoShot):
	global_position = currentPosition
	rotation = currentRotation
	if shooting:
		shoot(shootPos, playerWhoShot)

func Die():
	queue_free()
	emit_signal("PlayerHasDied")
