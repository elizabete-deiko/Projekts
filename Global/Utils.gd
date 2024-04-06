extends Node


var pause_menu
var paused = false

func save():
	var save_dict = {
		
		"Username" : Menu.username,
		"playerHP" : Game.playerHP,
		"Gold" : Game.Gold,
		"Position" : Vector3()
	}
	return save_dict

func save_Game():
	var save_game = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.WRITE, Menu.username)
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)

func load_Game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_game = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.READ, Menu.username)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data
		
		print(node_data)
func pause_play():
	paused = !paused
	
	pause_menu.visible = paused

func resume():
	pause_play()

func restart():
	Game.Gold = 0
	Game.playerHP = 100
	get_tree().reload_current_scene()

func load_world():
	get_tree().change_scene_to_file("res://main.tscn")

func quit():
	get_tree().quit()
