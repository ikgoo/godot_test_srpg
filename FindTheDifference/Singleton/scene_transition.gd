extends CanvasLayer

enum SceneName { 
	LOADING, 
	SELECTIMAGE,
	MAIN,
}

var scenesList : Array = [ 
	"res://Scenes/loading.tscn",
	"res://Scenes/select_image.tscn",
	"res://Scenes/main.tscn",
]

func _ready():
	pass
	

func change_scene(target: SceneName, duration : float) -> void:
	$Timer.start(duration)
	await $Timer.timeout
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scenesList[target])
	$AnimationPlayer.play_backwards("dissolve")	
