extends Node

@onready var parent = get_parent()
@onready var tutorial7_scene = load("res://scenes/menu_all/tutorial7.tscn")
@onready var main_menu_scene = load("res://scenes/menu_all/main_menu.tscn")
var new_scene = ""

func _on_next_pressed():
	parent.remove_child(parent.get_child(1))
	new_scene = tutorial7_scene.instantiate()
	parent.add_child(new_scene)


func _on_menu_pressed():
	parent.remove_child(parent.get_child(1))
	new_scene = main_menu_scene.instantiate()
	parent.add_child(new_scene)
	print(parent.get_child(0))
