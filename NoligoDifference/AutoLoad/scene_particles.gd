extends Control

signal ParticleEvent(particleName, globalPosition, delayTime)

# 클릭 하트
@onready var click_heart = preload("res://Particles/ClickHeart.tscn")

# 파티클 정보
enum ParticleName {
	CLICKHEART,
}
var particleList = []

func _ready():
	particleList.append(particleList)
	connect("ParticleEvent", PlayParticle)
	
func PlayParticle(_particleName, globalPosition1, _delayTime):
	var clickH = click_heart.instantiate()
	clickH.global_position = globalPosition1
	get_tree().current_scene.add_child(clickH)
	
	clickH.emitting = true
	pass
	
