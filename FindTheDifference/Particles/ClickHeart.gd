extends GPUParticles2D


func _process(delta):
	if emitting == true and lifetime <= 0:
		queue_free()
