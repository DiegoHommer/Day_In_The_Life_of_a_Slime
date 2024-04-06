extends Node

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_all/difficulty.tscn")
	

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_all/tutorial1.tscn")


func _on_scoreboard_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_all/scoreboard.tscn")


func _on_sair_pressed():
	get_tree().quit()
