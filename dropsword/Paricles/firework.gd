extends GPUParticles2D
@onready var gpu_particles_2d = $GPUParticles2D


func paticle_start(pos):
	global_position = pos
	gpu_particles_2d.emitting = true
	emitting = true
