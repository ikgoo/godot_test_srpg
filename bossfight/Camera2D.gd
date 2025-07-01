extends Camera2D
@onready var player = $"../player"
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position
	
func _physics_process(delta):
	if player.paring_g == true:
		camera_s()

func camera_s():
	animation_player.play("shake")
