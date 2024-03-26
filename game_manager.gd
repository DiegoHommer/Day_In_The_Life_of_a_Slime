extends Node
@onready var pc = %PC
@onready var qtd_filhos = %QtdFilhos
@onready var qtd_lixo = %QtdLixo


var trash = 0
var filhos_in_school = 0

# Função de absorção do lixo
func add_trash():
	trash += 1
	qtd_lixo.text = "lixos: " + str(trash)

# Função de atualização do lixo, quando fizer filho, tem que diminuir a qtd de
# lixo que possui 
func att_trash(lixo_por_filho):
	trash -= lixo_por_filho
	qtd_lixo.text = "lixos: " + str(trash)
	
func get_trash() -> int:
	return trash

# Função de "colocar" os filhos na escola
func go_to_school():
#atualiza a quantidade de filhos na escola
	filhos_in_school += pc.obter_filho_count()
	#zera a quantidade de filhos do pc
	pc.zerar_filho_count()
	#mata os filhos atuais do pc
	pc.matar_filhos()
	
	qtd_filhos.text = "escola: " + str(filhos_in_school)

