extends Node



func _on_next_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_all/tutorial4.tscn")


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_all/main_menu.tscn")
