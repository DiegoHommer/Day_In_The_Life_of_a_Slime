extends Area2D
@onready var game_manager = %GameManager
@onready var pc = %PC

func _on_body_entered(body):
	# Se o player entra em contato com o lixo, o lixo é absorvido
	if (body.name == "PC"):
		game_manager.add_trash()
		if (game_manager.get_trash() % pc.obter_lixo_por_filho()) == 0:
			pc.change_size(true)
		queue_free()
		
	
