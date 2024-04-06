extends Node
@onready var parent = get_parent()
@onready var difficulty_scene = load("res://scenes/menu_all/difficulty.tscn")
@onready var tutorial_scene = load("res://scenes/menu_all/tutorial1.tscn")
@onready var scoreboard_scene = load("res://scenes/menu_all/scoreboard.tscn")
var new_scene = ""

func _on_jogar_pressed():
	parent.remove_child(parent.get_child(1))
	new_scene = difficulty_scene.instantiate()
	parent.add_child(new_scene)


func _on_tutorial_pressed():
	parent.remove_child(parent.get_child(1))
	new_scene = tutorial_scene.instantiate()
	parent.add_child(new_scene)


func _on_scoreboard_pressed():
	parent.remove_child(parent.get_child(1))
	new_scene = scoreboard_scene.instantiate()
	parent.add_child(new_scene)


func _on_sair_pressed():
	get_tree().quit()
