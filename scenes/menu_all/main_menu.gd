extends Node
@onready var parent = get_parent()
@onready var backUI = parent.get_node("BackUI")
@onready var forwardUI = parent.get_node("ForwardUI")
@onready var difficulty_scene = load("res://scenes/menu_all/difficulty.tscn")
@onready var tutorial_scene = load("res://scenes/menu_all/tutorial1.tscn")
@onready var scoreboard_scene = load("res://scenes/menu_all/scoreboard.tscn")
var new_scene = ""

func _on_jogar_pressed():
	parent.remove_child(parent.get_child(3))
	new_scene = difficulty_scene.instantiate()
	parent.add_child(new_scene)
	forwardUI.play()


func _on_tutorial_pressed():
	parent.remove_child(parent.get_child(3))
	new_scene = tutorial_scene.instantiate()
	parent.add_child(new_scene)
	forwardUI.play()

func _on_scoreboard_pressed():
	parent.remove_child(parent.get_child(3))
	new_scene = scoreboard_scene.instantiate()
	parent.add_child(new_scene)
	forwardUI.play()

func _on_sair_pressed():
	forwardUI.play()
	get_tree().quit()
