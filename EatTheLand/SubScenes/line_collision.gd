extends Line2D

@onready var static_body_2d = $StaticBody2D

var lst_point = Vector2.ZERO

func addLine(point : Vector2) -> bool:
	
	var children = static_body_2d.get_children()
	var t = true
	for child in children:
		var s : SegmentShape2D = child.shape
		var result = Geometry2D.segment_intersects_segment(s.a, s.b, lst_point, point)
		if result != null && (result.x != lst_point.x || result.y != lst_point.y):
			return false
	
	var new_shape = CollisionShape2D.new()
	var segment = SegmentShape2D.new()
	segment.a = lst_point
	segment.b = point
	new_shape.shape = segment
	lst_point = point

	static_body_2d.add_child(new_shape)
	
	return true
