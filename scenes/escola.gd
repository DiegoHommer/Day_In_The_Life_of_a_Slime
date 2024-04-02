extends Area2D

@onready var pc = %PC
@onready var qtd_filhos = %QtdFilhos
@onready var game_manager = %GameManager
@onready var dia_timer = $"../UI/DiaTimer"


var aux_num_filho = 0
var school_position

func _ready():
	#position = Vector2(2000, -2000)
	position = Vector2(-1600,2000)
	school_position = position

func _on_body_entered(body):
	print(body.name)

	#se for dia, coloca os filhos na escola
	if dia_timer.dia:
		# Se o player entra em contato com a escola, começa a mandar os filhos pra escola
		if (body.name == "PC"):
			game_manager.going_school = true
			if pc.filho_count == 0:
				game_manager.going_school = false
			
		# Se o filho entra em contato com a escola, diminui o filho_count
		if body.name.begins_with("Filho"):
			#pega o número do filho que entrou na escola e mata ele
			aux_num_filho = body.numero
			pc.matar_filho(aux_num_filho)
			#atualiza quantos filhos o player tem
			pc.filho_count -= 1
			#atualiza no game_manager
			game_manager.att_school(true) #verdadeiro pq tá aumentando
			
			#quando todos os filhos do player forem para escola, pode fazer filhos normal
			if pc.filho_count == 0:
				game_manager.going_school = false
	#se não for dia(se já for horário de voltar pra casa), pegar os filhos
	else:
		if (body.name == "PC"):
			game_manager.leaving_school = true

