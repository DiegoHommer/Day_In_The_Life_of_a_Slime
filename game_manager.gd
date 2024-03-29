extends Node
@onready var pc = %PC
@onready var qtd_filhos = %QtdFilhos
@onready var qtd_lixo = %QtdLixo


var trash = 0
var lost_trash = 0
var filhos_in_school = 0

func game_over():
	print("morreu :(")

# Função de absorção do lixo
func add_trash():
	trash += 1
	#coloca na label (%QtdLixo) a quantidade de lixos
	qtd_lixo.text = "lixos: " + str(trash)
	
# Função de perda do lixo após player tomar hit
func lose_trash():
	if (trash > 0):
		var aux = trash
		trash = floor(float(trash)/2)
		lost_trash = aux - trash
		#coloca na label (%QtdLixo) a quantidade de lixos
		qtd_lixo.text = "lixos: " + str(trash)
	else:
		lost_trash = 0
		game_over()

# Função de atualização do lixo, quando fizer filho, tem que diminuir a qtd de
# lixo que possui 
func att_trash(lixo_por_filho):
	trash -= lixo_por_filho
	#coloca na label (%QtdLixo) a quantidade de lixos
	qtd_lixo.text = "lixos: " + str(trash)
	
func get_trash() -> int:
	return trash
	
func get_lost_trash() -> int:
	return lost_trash

# Função de "colocar" os filhos na escola
func go_to_school():
#atualiza a quantidade de filhos na escola
	filhos_in_school += pc.obter_filho_count()
	#zera a quantidade de filhos do pc
	pc.zerar_filho_count()
	#mata os filhos atuais do pc
	pc.matar_filhos()
	#coloca na label (%QtdFilhos) a quantidade de filhos na escola
	qtd_filhos.text = "escola: " + str(filhos_in_school)


