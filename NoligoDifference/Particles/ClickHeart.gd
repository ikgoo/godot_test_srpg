extends GPUParticles2D


func _process(_delta):
	if emitting == true and lifetime <= 0:
		queue_free()
