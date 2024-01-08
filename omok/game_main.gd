extends Node2D

var rows = 19
var columns = 19
var cell_size = 30


var loc = []


func _draw():
	loc.append("1")
	for i in range(rows):
		var y = i * cell_size
		draw_line(Vector2(0, y), Vector2(columns * cell_size, y), Color.BLACK, 0.5, true)

	for j in range(columns):
		var x = j * cell_size
		draw_line(Vector2(x, 0), Vector2(x, rows * cell_size), Color.BLACK, 0.5, true)
