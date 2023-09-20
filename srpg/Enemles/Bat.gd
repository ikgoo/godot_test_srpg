extends CharacterBody2D

@onready var states = $states
@onready var player_detection_zone = $PlayerDetectionZone
@onready var psrite = $AnimatedSprite
@onready var soft_collision = $SoftCollision
@onready var wander_controller = $WanderController
@onready var hurt_box = $HurtBox



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
	state = pick_random_state([EnemyState.IDLE, EnemyState.WANDER])
	
	

func _physics_process(delta):
#	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#	move_and_slide()
	
	match state:
		EnemyState.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_plaer()
			
			if wander_controller.get_time_left() == 0:
				update_wander()
			
		EnemyState.WANDER:
			seek_plaer()
			
			if wander_controller.get_time_left() == 0:
				update_wander()
				
			accelerate_towards_point(wander_controller.target_position, delta)
			
			if (global_position + velocity).distance_to(wander_controller.target_position) >= (global_position).distance_to(wander_controller.target_position):
				update_wander()
			
			
		EnemyState.CHASE:
			var player = player_detection_zone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = EnemyState.IDLE
				
	psrite.flip_h = velocity.x < 0
	
	# 몹끼리 충돌하면 밀어네는 로직
	if soft_collision.is_colliding():
		var tt = soft_collision.get_push_vector()
		velocity += tt * delta * 400
	
	move_and_slide()

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func update_wander():
	state = pick_random_state([EnemyState.IDLE, EnemyState.WANDER])
	wander_controller.start_wander_timer(randf_range(1, 3))

func seek_plaer():
	if player_detection_zone.can_see_player():
		state = EnemyState.CHASE

func pick_random_state(state_list : Array):
	state_list.shuffle()
	return state_list.pop_front()
	

func _on_hurt_box_area_entered(area):
	states.health -= area.damage
	velocity = area.knockback_vector * 120
	hurt_box.create_hit_effect()
	hurt_box.start_invicibility(1.5)
	


func _on_state_no_health():
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = self.global_position
	queue_free()
	
