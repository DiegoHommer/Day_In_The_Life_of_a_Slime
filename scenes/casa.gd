extends Area2D

@onready var pc = %PC
@onready var qtd_filhos = %QtdFilhos
@onready var game_manager = %GameManager
@onready var dia_timer = $"../UI/DiaTimer"


var aux_num_filho = 0
var home_position

func _ready():


	position = Vector2(-2300,2300)
	home_position = position


func _on_body_entered(body):
	print(body.name)

	#se for noite, pode colocar os filhos em casa
	if dia_timer.dia == false:
		# Se o player entra em contato com a casa, começa a mandar os filhos pra casa
		if (body.name == "PC"):
			game_manager.going_home = true
			if pc.filho_count == 0:
				game_manager.going_home = false
			
		# Se o filho entra em contato com a escola, diminui o filho_count
		if body.name.begins_with("Filho"):
			#pega o número do filho que entrou na casa e mata ele
			aux_num_filho = body.numero
			pc.matar_filho(aux_num_filho)
			#atualiza quantos filhos o player tem
			pc.filho_count -= 1
			#atualiza no game_manager
			game_manager.att_home(true) #verdadeiro pq tá aumentando
			
			#quando todos os filhos do player forem para casa, pode fazer filhos normal
			if pc.filho_count == 0:
				game_manager.going_home = false


