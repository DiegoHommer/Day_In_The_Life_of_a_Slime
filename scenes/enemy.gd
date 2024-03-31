extends CharacterBody2D
var game_manager = ""
var pc = ""
var immunity_timer = ""
var player_sprite = ""
var heatmap = ""

const X = 50
const Y = 50
const enemy_velocity = 150
var bodies_inside = 0
var rand_float = 0
var move = true
var chase = false

func _ready():
	if get_parent().has_method("gerar_inimigos"):
		owner = get_parent().owner
	game_manager = %GameManager
	pc = %PC
	immunity_timer = %PC/ImmunityTimer
	player_sprite = %PC/Polygon2D
	heatmap = %gerador_do_heatmap

	velocity = Vector2(enemy_velocity, enemy_velocity)
  


func _on_dash_timer_timeout():	
	if (chase):
		# Persegue o player pegando sua posição
		var distance = pc.global_position - self.global_position
		distance = distance.normalized()
		velocity = distance * enemy_velocity
	else:
		# 50% de chance de...
		if (randf() >= 0.5):
			var decided_destiny = false
			var x_index = (self.position.x + (heatmap.HEATMAP_SIZE/2)) / 320
			var y_index = (self.position.y + (heatmap.HEATMAP_SIZE/2)) / 320
			
			while (not decided_destiny):
				# Sorteia um dos quadrados do heatmap em volta
				var rand_x = randi_range(max(x_index - 1, 0),max(x_index + 1,heatmap.HEATMAP_SIZE - 1))
				var rand_y = randi_range(max(y_index - 1, 0),max(y_index + 1,heatmap.HEATMAP_SIZE - 1))
				
				# Quadrado com nível mais alto tem mais probabilidade de ser destino
				if (randf_range(0,1)*(heatmap.areas[rand_x][rand_y].level+1)>0.92):
					decided_destiny = true
					var destiny_x = heatmap.areas[rand_x][rand_y].position.x + 320*randf()
					var destiny_y = heatmap.areas[rand_x][rand_y].position.y + 320*randf()
					velocity = Vector2(destiny_x,destiny_y) - self.position
					velocity = velocity.normalized() * enemy_velocity
					
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move


func _physics_process(_delta):
	if (move):
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


# Função para quando player/filho entra na visão do inimigo
func _on_vision_body_entered(body):
	if (body.name == "PC" or body.name.contains("Filho")):
		bodies_inside += 1
		chase = true


# Função para quando player/filho sai da visão do inimigo
func _on_vision_body_exited(body):
	if (body.name == "PC" or body.name.contains("Filho")):
		bodies_inside -= 1
		
		# Quando todos os filhos e o player saíram da visão, para de perseguir
		if (bodies_inside == 0):
			chase = false
