extends GPUParticles2D
var jwung = ""
const NEW_PISKEL__3_ = preload("res://New Piskel (3).png")
const NEW_PISKEL__2_ = preload("res://New Piskel (2).png")
const NEW_PISKEL__1_ = preload("res://New Piskel (1).png")
var mob = "null"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if jwung == "perfect":
		emitting = true
		if mob != null:
			mob.hurt(20)
	if jwung == "good":
		texture = NEW_PISKEL__1_
		if mob != null:
			mob.hurt(10)
		emitting = true
	if jwung == "bad":
		texture = NEW_PISKEL__2_
		if mob != null:
			mob.hurt(5)
		emitting = true
	if jwung == "miss":
		texture = NEW_PISKEL__3_
		emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_finished() -> void:
	queue_free()
