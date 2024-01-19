extends Node

var save_path = "user://GameData.tres"
var win_count: int = 0
var lose_count: int = 0



func SaveData():
	var saveData: GameResourceData = GameResourceData.new()
	saveData.win_count = win_count
	saveData.lose_count = lose_count
	
	ResourceSaver.save(saveData, save_path)


func LoadData():
	var loadData: GameResourceData = ResourceLoader.load(save_path)
	win_count = loadData.win_count
	lose_count = loadData.lose_count
