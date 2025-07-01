extends AudioStreamPlayer2D
@onready var timer: Timer = $Timer

var jwung_things = ["bad","good","perfect","miss"]
var jwung = "miss"
var what = -1
const PARING_JWUNG = preload("res://paring_jwung.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playing = true

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("paring"):
		#if get_parent().ok(self):
			#var paring_j = PARING_JWUNG.instantiate()
			#paring_j.jwung = jwung
			#get_parent().add_child(paring_j)
			#queue_free()
			
		

func timer_go():
	timer.start()

func tick():
	playing = false
	playing = true


#func _on_timer_timeout() -> void:
	#if what == 3:
		#var paring_j = PARING_JWUNG.instantiate()
		#paring_j.jwung = jwung
		#get_parent().add_child(paring_j)
		#queue_free()
	#else:
		#jwung = jwung_things[what+1]
		#what += 1
		#timer.start()
