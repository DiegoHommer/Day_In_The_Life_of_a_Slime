extends Node2D
@onready var menu_theme = self.get_node("MenuTheme")

func _on_menu_theme_finished():
	menu_theme.play()
