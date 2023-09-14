extends CharacterBody2D

@onready var states = $states
@onready var player_detection_zone = $PlayerDetectionZone
@onready var psrite = $AnimatedSprite

@export var ACCELERATION = 350
@export var MAX_SPEED = 40
@export var FRICTION = 200

var EnemyDeathEffect : Resource = preload("res://Enemles/enemy_death_effet.tscn")

enum EnemyState {
	IDLE,
	WANDER,
	CHASE
}

var state : EnemyState = EnemyState.IDLE


func _ready():
	velocity = Vector2.ZERO
	

func _physics_process(delta):
#	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#	move_and_slide()
	
	match state:
		EnemyState.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_plaer()
			pass
		EnemyState.WANDER:
			pass
		EnemyState.CHASE:
			var player = player_detection_zone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = EnemyState.IDLE
				
	psrite.flip_h = velocity.x < 0
	move_and_slide()

func seek_plaer():
	if player_detection_zone.can_see_player():
		state = EnemyState.CHASE

func _on_hurt_box_area_entered(area):
	states.health -= area.damage
	velocity = area.knockback_vector * 120


func _on_state_no_health():
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = self.global_position
	queue_free()
	
