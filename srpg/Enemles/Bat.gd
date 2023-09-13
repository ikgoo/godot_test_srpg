extends CharacterBody2D

@onready var state = $state
var EnemyDeathEffect : Resource = preload("res://Enemles/enemy_death_effet.tscn")

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()
		


func _on_hurt_box_area_entered(area):
	state.health -= area.damage
	velocity = area.knockback_vector * 120


func _on_state_no_health():
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = self.global_position
	queue_free()
	
