extends Control

@onready var grid_container = $ScrollContainer/GridContainer

@onready var texture_rect = preload("res://Singleton/texture_rect.tscn")

var selectImageList = []

func _ready():
	
	for i in range(SingletonMainData.dateList.size()):
		var tmptr : TextureRect = texture_rect.instantiate() as TextureRect
		
		var curDate = SingletonMainData.dateList[i]
		
		var path = "user://main_" + curDate + ".jpg"

		var img = Image.new()
		var tex = ImageTexture.new()
		var file : FileAccess = FileAccess.open(path, FileAccess.READ)
		var img_buffer = file.get_buffer(file.get_length())
		img.load_jpg_from_buffer(img_buffer)
		tex.set_image(img)	
		
		tmptr.texture = tex
		tmptr.curData = SingletonMainData.mainJsonData["datas"][curDate]["data"]
		tmptr.curDate = curDate
		tmptr.connect("SelectImage", SelectImage)
		selectImageList.append(tmptr)
		grid_container.add_child(tmptr)
	
	print(SingletonMainData.dateList)
	
	
	

func SelectImage(curDate):
	# 연결 시그널을 모두 끊음
	for i in range(selectImageList.size()):
		selectImageList[i].disconnect("SelectImage", SelectImage)
		
	selectImageList.clear()
	
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
