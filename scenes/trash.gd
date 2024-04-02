extends Area2D
@onready var game_manager = ""
@onready var pc = ""

func _ready():
	#fiz isso porque os lixos spawnados não tavam achando o GameManager e o PC do jeito que tava
	owner = get_parent().owner  
		
	game_manager = %GameManager
	pc = %PC


func _on_body_entered(body):
	# Se o player entra em contato com o lixo, o lixo é absorvido
	if (body.name == "PC" and pc.tamanho <= pc.MAX_TAMANHO):
		game_manager.add_trash()
		
		pc.change_size(true)
		queue_free()
		
	
