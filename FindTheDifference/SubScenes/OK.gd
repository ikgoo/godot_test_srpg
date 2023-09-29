extends Control



func init(diffData):
	var ok_image = get_child(0)
	ok_image.position.x = diffData["x"] - 5
	ok_image.position.y = diffData["y"] - 5
	ok_image.custom_minimum_size.x = diffData["width"] + 15
	ok_image.custom_minimum_size.y = diffData["height"] + 15
	ok_image.size.x = diffData["width"] + 15
	ok_image.size.y = diffData["height"] + 15
	
