extends ProgressBar
@onready var damage_bar: ProgressBar = $damage_bar
@onready var timer: Timer = $Timer

var health = 0

func _set_health(new_health):
	var prev_health = health
	health = min(max_value,new_health)
	value = health
	
	if health <= 0:
		get_parent().queue_free()
	if health < prev_health:
		timer.start()
func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_timer_timeout() -> void:
	damage_bar.value = health
