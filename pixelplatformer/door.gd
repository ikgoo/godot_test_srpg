extends Area2D

@export_file("*.tscn") var target_level_path: String = ""

var over_player = false

func go_to_next_room():
	over_player = false
	var getTree = get_tree()
	getTree.paused = true
	Transitions.play_exit_transition()
	await Transitions.transition_completed
	get_tree().change_scene_to_file(target_level_path)
	getTree.paused = false
	Transitions.play_enter_transition()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_down") and over_player == true:
		if target_level_path.is_empty(): return 
		
		go_to_next_room()


func _on_body_entered(body):
	if not body is Player: return 
	over_player = true
	

func _on_body_exited(body):
	if not body is Player: return 
	over_player = false

