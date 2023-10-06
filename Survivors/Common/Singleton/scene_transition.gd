extends CanvasLayer

# Scene 이동 처리
# SceneName : Scene 이름 등록
# scenesList : Scene의 리소스 경로 등록
# SceneName, scenesList 두개의 변수의 개수가 맞아야 함

@onready var dissolve_rect = $DissolveRect


# Fade 시 색상
@export var fadeInOutColor : Color = Color.GRAY : set = setFadeInOutColor
func setFadeInOutColor(value):
	fadeInOutColor = value
func _process(delta):
	pass

# Scene 이동 리스트
enum SceneName { 
	MAINMENU, 
	MAIN,
}

# Scene 리소스 리스트
var scenesList : Array = [ 
	# LOADING
	"res://Scenes/main_menu.tscn",
	"res://Scenes/game_scene.tscn",
]

#  Fade 방식
enum TransType {
	Fade,
#	DownUp,
}

func _ready():
	dissolve_rect.color = fadeInOutColor

# Scene 이동 함수
# target : SceneName 명칭으로 이동한 Scene 값 전달
# transType : fade 방식
func change_scene(target: SceneName, transType : TransType) -> void:
	
	if transType == TransType.Fade:
		MoveFadeInOut(target)
#	elif transType == TransType.DownUp:
#		MoveDownUp(target)
	
# Fade In Out 방식 이동		
func MoveFadeInOut(target: SceneName) -> void:
	$AnimationPlayer.play("fadeinout")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scenesList[target])
	$AnimationPlayer.play_backwards("fadeinout")	
	
#func MoveDownUp(target: SceneName) -> void:
#	$AnimationPlayer.play("downin")
#	await $AnimationPlayer.animation_finished
#	get_tree().change_scene_to_file(scenesList[target])
#	$AnimationPlayer.play("upout")	
