extends Area2D
@onready var game_manager = %GameManager
@onready var pc = %PC
@onready var immunity_timer = %PC/ImmunityTimer
@onready var player_sprite = %PC/Polygon2D

func _ready():
	if get_parent().has_method("gerar_inimigos"):
		owner = get_parent().owner
	game_manager = %GameManager
	pc = %PC
	immunity_timer = %PC/ImmunityTimer
	player_sprite = %PC/Polygon2D
# Função de ataque contra o player
func attack():
	game_manager.lose_trash() # PC perde metade do lixo
	pc.change_size(false) # PC diminui em tamanho
	player_sprite.set_color(Color(0,0,0,255)) # PC muda de sprite
	immunity_timer.start() # PC recebe tempo de imunidade


# Função para quando player/filho toca no hitbox do inimigo
func _on_body_entered(body):
	# Se o player entra em contato com o inimigo quando sua imunidade está desligada, player é atacado
	if (body.name == "PC"):
		if (immunity_timer.is_stopped()):
			attack()
			
	# Se o filho entra em contato com o inimigo, filho e todos os irmãos que estão seguindo ele são deletados
	elif(body.name == "Filho"):
		for brother in body.parent.get_children():
			if(brother.name != "PC"):
				if (brother.get_number() > body.get_number()):
					body.parent.remove_child(brother)
					brother.queue_free() 
		body.queue_free()
