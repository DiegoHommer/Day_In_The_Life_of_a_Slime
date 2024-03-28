extends Area2D

@onready var pc = %PC
@onready var qtd_filhos = %QtdFilhos
@onready var game_manager = %GameManager

func _ready():
	position = Vector2(1800, -1800)

func _on_body_entered(body):
	# Se o player entra em contato com a escola, filhos morrem e add count
	if (body.name == "PC"):
		game_manager.go_to_school()

