extends Control

var username = ""
var password 

var created = false

func _on_login_button_down():
	if !created:
		username = $Panel/Username.text
		password = $Panel/Password.text.sha256_text()
		created = true
		$Panel/Login.text = "Login"
		$Panel/Username.text = ""
		$Panel/Password.text = ""
		Utils.save()
	else:
		if $Panel/Username.text == username:
			if $Panel/Password.text.sha256_text() == password:
				
				print("Login Success")
				get_tree().change_scene_to_file("res://main.tscn")
			else:
				print("Login Fail")
		else:
			print("Login Fail")
