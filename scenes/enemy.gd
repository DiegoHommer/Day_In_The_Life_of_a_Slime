extends CharacterBody2D
@onready var game_manager = %GameManager
@onready var pc = %PC
@onready var immunity_timer = %PC/ImmunityTimer
@onready var player_sprite = %PC/Polygon2D

const X = 50
const Y = 50
var rand_float = 0
var move = true


func _on_dash_timer_timeout():
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move
	
	# randf sorteia um float entre 0.0 e 1.0 (dá pra brincar com a probabilidade dos movimentos com isso) 
	rand_float = randf()
	


func _physics_process(_delta):
	if (move):
		velocity = Vector2(X,Y)
		
		# 50% manter direção, 25% de chance de inverte eixo X, 25% de inverter ambos os eixos (só pra testar)
		if (rand_float >= 0.5 and rand_float <= 0.75):
			velocity = Vector2(-X,Y)
		elif (rand_float >= 0.75):
			velocity = Vector2(-X,-Y)
		
		move_and_slide()
	


# Função de ataque contra o player
func attack():
	game_manager.lose_trash() # PC perde metade do lixo
	pc.change_size(false) # PC diminui em tamanho
	player_sprite.set_color(Color(0,0,0,255)) # PC muda de sprite
	immunity_timer.start() # PC recebe tempo de imunidade


# Função para quando player/filho toca no hitbox do inimigo
func _on_area_2d_body_entered(body):
	# Se o player entra em contato com o inimigo quando sua imunidade está desligada, player é atacado
	if (body.name == "PC"):
		if (immunity_timer.is_stopped()):
			attack()
			
	# Se o filho entra em contato com o inimigo, filho e todos os irmãos que estão seguindo ele são deletados
	elif(body.name.contains("Filho")):
		var mortos = 1
		for brother in body.parent.get_children():
			if(brother.name != "PC"):
				if (brother.get_number() > body.get_number()):
					mortos += 1
					body.parent.remove_child(brother)
					brother.queue_free() 
		pc.subtrair_filho_count(mortos)
		body.queue_free()


