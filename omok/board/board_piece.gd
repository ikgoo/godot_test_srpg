@tool
extends Area2D
class_name BoardPiece

signal PieceOver
signal PieceClick

@onready var piece = $Piece

enum PieceType {
	LEFTTOP = 0,
	TOP = 1,
	RIGHTTOP = 2,
	LEFT = 3,
	CENTER = 4,
	RIGHT = 5,
	LEFTBOTTOM = 6,
	BOTTOM = 7,
	RIGTHBOTTOM = 8,
}
var area2DPosition = [
	[0, 0], 	# center
	[0, -5], 	# top
	[0, 5], 	# bottom
	[-5, 0], 	# left
	[5, 0], 	# right
	[-5, -5],	# lefttop
	[5, -5],	# righttop
	[5, 5],		# rightbottom
	[-5, 5],	# leftbottom
]
@export var pieceType : PieceType = PieceType.CENTER : set = SetPieceType
func SetPieceType(value):
	pieceType = value
	if piece:
		piece.region_rect = Rect2(pieceType * 34, 0, 34, 34)


var boardPosition = [0, 0]

func _ready():
	if Engine.is_editor_hint():
		piece = $Piece
		pieceType = PieceType.LEFT

func SetBoardPosition(posx, posy):
	boardPosition = [posx, posy]

func _on_mouse_entered():
	emit_signal("PieceOver", boardPosition)


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("PieceClick", boardPosition)
