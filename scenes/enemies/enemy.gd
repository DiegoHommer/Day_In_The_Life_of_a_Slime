extends CharacterBody2D
var game_manager = ""
var pc = ""
var immunity_timer = ""
var player_sprite = ""
var heatmap = ""

const X = 50
const Y = 50
const enemy_velocity = 300
const archer_velocity = 800
var bodies_inside = 0
var rand_float = 0
var move = true
var chase = false
var spotted = false
var shooting = false
var arrow_shoot = ""
var sword_hit = ""
var glare = ""
var enemy_type = "Warrior"
var enemy_sprite = "WarriorSprite"
var arrow_scene = preload("res://scenes/enemies/arrow.tscn")

func _ready():
	if get_parent().has_method("gerar_inimigos"):
		owner = get_parent().owner
	game_manager = owner.get_node("GameManager")
	pc = owner.get_node("Familia/PC")
	arrow_shoot = pc.get_node("SFX/ArrowShoot")
	sword_hit = pc.get_node("SFX/Swordhit")
	glare = pc.get_node("SFX/Glare")
	immunity_timer = owner.get_node("Familia/PC/ImmunityTimer")
	heatmap = owner.get_node("gerador_do_heatmap")
	if (enemy_type == "Warrior"):
		enemy_sprite = self.get_node("WarriorSprite")
		self.get_node("ArcherSprite").visible = false
	elif (enemy_type == "Archer"):
		enemy_sprite = self.get_node("ArcherSprite")
		self.get_node("WarriorSprite").visible = false
 

	velocity = Vector2(enemy_velocity, enemy_velocity)
  
func warrior_movement():
	if (chase):
		# Persegue o player pegando sua posição
		var distance = pc.global_position - self.global_position
		distance = distance.normalized()
		velocity = distance * enemy_velocity
	else:
		# 50% de chance de...
		if (randf() >= 0):
			
			var decided_destiny = false
			var x_index = int((self.position.x + (heatmap.HEATMAP_SIZE*320/2)) / 320)
			var y_index = int((self.position.y + (heatmap.HEATMAP_SIZE*320/2)) / 320)
			
			while (not decided_destiny):
				
				# Sorteia um dos quadrados do heatmap em volta
				var rand_x = randi_range(max(x_index - 1, 0),min(x_index + 1,heatmap.HEATMAP_SIZE - 1))
				var rand_y = randi_range(max(y_index - 1, 0),min(y_index + 1,heatmap.HEATMAP_SIZE - 1))
				
				# Quadrado com nível mais alto tem mais probabilidade de ser destino
				if (randf_range(0,1)*(heatmap.areas[rand_x][rand_y].level+1)>0.85):
					decided_destiny = true
					var destiny_x = heatmap.areas[rand_x][rand_y].position.x + 320*randf()
					var destiny_y = heatmap.areas[rand_x][rand_y].position.y + 320*randf()
					#print(rand_x, ", ", rand_y)
					#print(destiny_x, ", " ,destiny_y)
					velocity = Vector2(destiny_x,destiny_y) - self.position
					velocity = velocity.normalized() * enemy_velocity
					
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move
	

func archer_movement():
	if (chase):
		# Persegue o player pegando sua posição
		var distance = pc.global_position - self.global_position
		distance = distance.normalized()
		velocity = distance
	else:
		# 50% de chance de...
		if (randf() >= 0):
			
			var decided_destiny = false
			var x_index = int((self.position.x + (heatmap.HEATMAP_SIZE*320/2)) / 320)
			var y_index = int((self.position.y + (heatmap.HEATMAP_SIZE*320/2)) / 320)
			
			while (not decided_destiny):
				
				# Sorteia um dos quadrados do heatmap em volta
				var rand_x = randi_range(max(x_index - 1, 0),min(x_index + 1,heatmap.HEATMAP_SIZE - 1))
				var rand_y = randi_range(max(y_index - 1, 0),min(y_index + 1,heatmap.HEATMAP_SIZE - 1))
				
				# Quadrado com nível mais alto tem mais probabilidade de ser destino
				if (randf_range(0,1)*(heatmap.areas[rand_x][rand_y].level+1)<=0.85):
					decided_destiny = true
					var destiny_x = heatmap.areas[rand_x][rand_y].position.x + 320*randf()
					var destiny_y = heatmap.areas[rand_x][rand_y].position.y + 320*randf()
					#print(rand_x, ", ", rand_y)
					#print(destiny_x, ", " ,destiny_y)
					velocity = Vector2(destiny_x,destiny_y) - self.position
					velocity = velocity.normalized() * archer_velocity
					
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move
	
	
func animation_logic(distance):
	var direction_angle = distance.normalized().angle()
	var is_angry = "normal"
	
	if (not spotted):
		# Lógica verifica se inimigo está perseguindo player para mudar sprites
		if (chase):
			is_angry = "angry"
			
		if (cos(direction_angle) > (PI/4)):
			enemy_sprite.animation = "right_" + is_angry
		elif (cos(direction_angle) < (-PI/4)):
			enemy_sprite.animation = "left_" + is_angry
		elif (sin(direction_angle) < 0):
			enemy_sprite.animation = "up_" + is_angry
		else: 
			enemy_sprite.animation = "down_" + is_angry

func _on_dash_timer_timeout():
	match enemy_type:
		"Warrior": warrior_movement()
		"Archer": archer_movement()
		_: print("Tipo de inimigo inexistente")
	animation_logic(velocity)

func _physics_process(_delta):
	if (move):
		move_and_slide()
	

func shoot():
	var arrow = arrow_scene.instantiate()
	var distance = pc.position - self.position
	distance = distance.normalized()
	arrow.new_arrow(distance, self.position)
	owner.call_deferred("add_child", arrow)
	arrow_shoot.play()

# Função de ataque contra o player
func attack():
	game_manager.lose_trash() # PC perde metade do lixo
	pc.change_size(false) # PC diminui em tamanho
	immunity_timer.start() # PC recebe tempo de imunidade



# Função para quando player/filho toca no hitbox do inimigo
func _on_area_2d_body_entered(body):
	if (enemy_type == "Warrior"):
		# Se o player entra em contato com o inimigo quando sua imunidade está desligada, player é atacado
		if (body.name == "PC"):
			if (immunity_timer.is_stopped()):
				attack()
				sword_hit.play()
				
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


# Função para quando player/filho entra na visão do inimigo
func _on_vision_body_entered(body):
	if (body.name == "PC" or body.name.contains("Filho")):
		bodies_inside += 1
		chase = true
		if (bodies_inside == 1 and enemy_type == "Archer"):
			spotted = true
			enemy_sprite.animation = "spotted"
			glare.play()



# Função para quando player/filho sai da visão do inimigo
func _on_vision_body_exited(body):
	if (body.name == "PC" or body.name.contains("Filho")):
		bodies_inside -= 1
		
		# Quando todos os filhos e o player saíram da visão, para de perseguir
		if (bodies_inside == 0):
			chase = false


func _on_warrior_sprite_animation_changed():
	enemy_sprite.play()


func _on_archer_sprite_animation_changed():
	enemy_sprite.play()


func _on_archer_sprite_frame_changed():
	if (enemy_sprite.animation.contains("angry") and enemy_sprite.frame == 3):
		shoot()


func _on_archer_sprite_animation_looped():
	if (enemy_sprite.animation == "spotted"):
		spotted = false
