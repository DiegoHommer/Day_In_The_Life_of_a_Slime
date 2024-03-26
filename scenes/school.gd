extends Area2D

@onready var pc = %PC


var filhos_in_school = 0


func _on_body_entered(body):
	# Se o player entra em contato com a escola, filhos morrem e add count
	if (body.name == "PC"):
		#atualiza a quantidade de filhos na escola
		#filhos_in_school += pc.obter_filho_count()
		#zera a quantidade de filhos do pc
		#pc.zerar_filho_count()
		#mata os filhos atuais do pc
		pc.matar_filhos()




