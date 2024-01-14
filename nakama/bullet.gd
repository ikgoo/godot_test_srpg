extends Area2D

var speed: int = 750
var playerWhoShot
var timeToLive = 100

func _ready():
	pass
	
func _physics_process(delta):
	timeToLive -= delta
	if timeToLive < 0:
		queue_free()
	position += transform.x * speed * delta


func _on_body_entered(body):
	print("hit player: " + str(body))
	if body.name != playerWhoShot:
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(body, "Die")
