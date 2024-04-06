extends CharacterBody2D


const SPEED = 400
var direction = ""
var pc = ""
var arrow_hit = ""
var immunity_timer = ""
var player_sprite = ""
var game_manager = ""

func _ready():
	var parent = get_parent()
	game_manager = parent.get_node("GameManager")
	pc = parent.get_node("Familia/PC")
	arrow_hit = pc.get_node("SFX/Arrowhit")
	immunity_timer = parent.get_node("Familia/PC/ImmunityTimer")
	
	
func new_arrow(initial_direction, initial_position):
	self.direction = initial_direction 
	self.position = initial_position
	rotation = (direction.angle() + PI/2)


func _physics_process(_delta):
	velocity = direction * SPEED
	move_and_slide()


func _on_airtime_timeout():
	queue_free()


# Função de ataque contra o player
func attack():
	game_manager.lose_trash() # PC perde metade do lixo
	pc.change_size(false) # PC diminui em tamanho
	immunity_timer.start() # PC recebe tempo de imunidade


func _on_hitbox_body_entered(body):
	# Se o player entra em contato com o inimigo quando sua imunidade está desligada, player é atacado
	if (body.name == "PC"):
		if (immunity_timer.is_stopped()):
			attack()
		arrow_hit.play()
			
	# Se o filho entra em contato com o inimigo, filho e todos os irmãos que estão seguindo ele são deletados
	elif(body.name.contains("Filho") and (not body.dead)):
		var mortos = 1
		for brother in body.parent.get_children():
			if(brother.name != "PC" and (not brother.dead)):
				if (brother.get_number() > body.get_number()):
					mortos += 1
					brother.die()
		pc.subtrair_filho_count(mortos)
		body.die()
	
	elif (body.name != "Enemy"):
		queue_free()
