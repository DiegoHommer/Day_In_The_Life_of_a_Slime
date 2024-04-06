extends Area2D
@onready var game_manager = ""
@onready var pc = ""
var um_lixo = 1
var trash_sound = ""
func _ready():
	#fiz isso porque os lixos spawnados não tavam achando o GameManager e o PC do jeito que tava
	owner = get_parent().owner  
	game_manager = owner.get_node("GameManager")
	pc = owner.get_node("Familia/PC")
	trash_sound = pc.get_node("SFX/Eat")
	

func _on_body_entered(body):
	# Se o player entra em contato com o lixo, o lixo é absorvido
	if (body.name == "PC" and pc.tamanho <= pc.MAX_TAMANHO):
		game_manager.add_trash(um_lixo)
		trash_sound.play()
		pc.change_size(true)
		queue_free()
		
	
