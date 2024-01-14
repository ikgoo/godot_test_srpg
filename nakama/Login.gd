extends Control


func _on_register_pressed():
	var username = $UsernameText.text
	var password = $PasswordText.text
	var email = $EmailText.text
	
	var session : NakamaSession = await Online.nakama_client.authenticate_email_async(email, password, username, true)
	if session.is_exception():
		print(session.get_exception().message)
		return
	Online.nakama_session = session
	hide()
	$"../FindMatch".show()

func _on_login_pressed():
	var username = $UsernameText.text
	var password = $PasswordText.text
	var email = $EmailText.text
	
	var session : NakamaSession = await Online.nakama_client.authenticate_email_async(email, password, null, false)
	if session.is_exception():
		print(session.get_exception().message)
		return
	Online.nakama_session = session
	hide()
	$"../FindMatch".show()
