extends Timer
@onready var timer: Timer = $"."
var jwung_things = ["perfect","good","bad","miss"]
var jwung = "miss"
var what = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func timer_go():
	timer.start()

func _on_timeout() -> void:
	jwung = jwung_things[what+1]
	what += 1

func tick():
	self.playing = true
