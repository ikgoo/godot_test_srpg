extends Node2D

@export var maxFindCount = 5;
@export var findCount : int = 0 : set = setFindCount;

signal StageEnd

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(lmaxFindCount):
	maxFindCount = lmaxFindCount

func start(lmaxFindCount):
	pass

func setFindCount(value):
	findCount = value
	print(findCount)
	if(findCount == maxFindCount):
		print('게임 끝')
		emit_signal("StageEnd")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
