extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.pause_menu = $PauseMenu


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		Utils.pause_play()



func _on_resume_pressed():
	Utils.resume()


func _on_restart_pressed():
	Utils.restart()


func _on_menu_pressed():
	Utils.load_world()


func _on_quit_pressed():
	Utils.quit()
