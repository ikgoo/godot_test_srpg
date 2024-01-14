extends Control
class_name UserReady


var readyText
var username

func setReady(_readyText):
	$Ready.text = _readyText
	readyText = _readyText

func setUsername(_username):
	$Username.text = _username
	username = _username
	
