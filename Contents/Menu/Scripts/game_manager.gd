extends Node

var game_started = false
var game_scene_path = "res://Contents/Scene/zone_1.tscn"  # Chemin vers la scène de jeu

func start_game():
	game_started = true
	get_tree().change_scene_to_file(game_scene_path)

func reset_game():
	game_started = true
	get_tree().reload_current_scene()

func exit_game():
	get_tree().quit()

func return_to_main_menu():
	game_started = false
	get_tree().change_scene_to_file("res://Contents/Menu/UI/mainmenu_scene.tscn")
