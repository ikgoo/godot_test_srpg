extends Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var jwung_r = "nothing"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.speed_scale = 1
	animation_player.play("new_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func perfect():
	jwung_r = "perfect"

func good():
	jwung_r = "good"

func bad():
	jwung_r = "bad"

func miss():
	jwung_r = "miss"

func give_j():
	return jwung_r

func _que():
	queue_free()
