extends Node


func _on_easy_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://main.tscn")



func _on_medium_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://main.tscn")


func _on_hard_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://main.tscn")


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_all/main_menu.tscn")
