extends Node

@onready var parent = get_parent()
@onready var backUI = parent.get_node("BackUI")
@onready var forwardUI = parent.get_node("ForwardUI")
@onready var tutorial4_scene = load("res://scenes/menu_all/tutorial4.tscn")
@onready var main_menu_scene = load("res://scenes/menu_all/main_menu.tscn")
var new_scene = ""

func _on_next_pressed():
	parent.remove_child(parent.get_child(3))
	new_scene = tutorial4_scene.instantiate()
	parent.add_child(new_scene)
	forwardUI.play()


func _on_menu_pressed():
	parent.remove_child(parent.get_child(3))
	new_scene = main_menu_scene.instantiate()
	parent.add_child(new_scene)
	backUI.play()
