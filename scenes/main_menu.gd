extends Node

func _on_jogar_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://main.tscn")
	
func _process(_delta):
	if Input.is_action_pressed("dash_filho"):
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		get_tree().change_scene_to_file("res://main.tscn")
