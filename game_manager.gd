extends Node
@onready var pc = %PC
@onready var qtd_filhos = %QtdFilhos
@onready var qtd_lixo = %QtdLixo

var trash = 0
var lost_trash = 0
var filhos_in_school = 0
var filhos_in_casa = 0

#variável que mostra se os filhos estão indo para escola ou não
var going_school = false
#variável que mostra se os filhos estão saindo da escola ou não
var leaving_school = false
#variável que mostra se os filhos estão indo para casa ou não
var going_home = false

func game_over():
	print("morreu :(")

# Função de absorção do lixo
func add_trash():
	trash += 1
	#coloca na label (%QtdLixo) a quantidade de lixos
	qtd_lixo.text = "lixos: " + str(trash)
	
# Função de absorção do lixo
func add_five_trash():
	trash += 5
	#coloca na label (%QtdLixo) a quantidade de lixos
	qtd_lixo.text = "lixos: " + str(trash)
	
	
# Função de perda do lixo após player tomar hit
func lose_trash():
	if (trash > 0):
		var aux = trash
		#arredonda pra baixo
		trash = floor(float(trash)/2)
		lost_trash = aux - trash
		#coloca na label (%QtdLixo) a quantidade de lixos
		qtd_lixo.text = "lixos: " + str(trash)
	else:
		lost_trash = 0
		game_over()

#função que gasta o número de lixos para dar um_dash/fazer_filho
func spend_trash():
	if(trash >= pc.LIXO_POR_FILHO):
		lost_trash = pc.LIXO_POR_FILHO
		att_trash(pc.LIXO_POR_FILHO)

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
func att_school(aumentou):
#atualiza a quantidade de filhos na escola
	if aumentou:
		filhos_in_school += 1
	else:
		filhos_in_school -= 1
	#coloca na label (%QtdFilhos) a quantidade de filhos na escola
	qtd_filhos.text = "escola: " + str(filhos_in_school)


# Função de "colocar" os filhos em casa
func att_home(aumentou):
#atualiza a quantidade de filhos na escola
	if aumentou:
		filhos_in_casa += 1
	else:
		filhos_in_casa -= 1
	
	print("Tenho" + str(filhos_in_casa) + "filhos em casa")
