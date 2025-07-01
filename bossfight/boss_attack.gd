extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cpu_particles_2d.emitting = true
	var tween = get_tree().create_tween()
	
	tween.tween_property(self,"modulate",Color(1,1,1,1),0.3)
	
	await tween.finished
	
	animation_player.play("ending")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() != Node2D:
		area.get_parent().mob_attack(10,self,false)
