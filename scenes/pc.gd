extends CharacterBody2D

#movimento------------------------------------------------------------------------------
const BASE_SPEED = 450
#quão mais rápido é com o dash
const SPEED_MULTIPLIER = 2.5
@export var speed = BASE_SPEED
var move = true
var direction = Vector2(0,0)
#variável para dizer se acabou de fazer um filho (não se possui filhos atualmente) 
#se for pai irá dar o dash (variável apenas para controlar o dash)
var is_dad = false
#variável para saber qual a velocidade do pai
var dad_speed = 0

var time = 0


#controle------------------------------------------------------------------------------

@onready var cursor = %cursor
var direction_x = 0
var direction_y = 0
var control_mode = 1
var stick_left = 0
var stick_right = 0

#tamanho------------------------------------------------------------------------------
const SIZE_CHANGE = 0.2
var escala = 8
#esse parâmetro controla o quão forte é a desaceleração dele quando ele cresce
#se é 1, ele fica duas vezes mais lento quando tá duas vezes maior. Botei 0.5 porque parecia melhor, mas dá pra mudar
const SLOW_DOWN = 0.5
#variável para dizer qual o tamanho do slime pai, indo de 0 até 9
var tamanho = 0
const MAX_TAMANHO = 9

#filhos-------------------------------------------------------------------------------
var filho_scene = preload("res://scenes/filho.tscn")
#quantos filhos ele tem com ele
var filho_count = 0
const LIXO_POR_FILHO = 1
var parent = ""
var dash_sound = ""
var child_spawn_sound = ""
var tempo = 0

#lixo-------------------------------------------------------------------------------
@onready var game_manager = %GameManager

#animation--------------------------------------------------------------------------
@onready var animationPlayer = self.get_node("AnimationPlayer")
var tamanho_aux = 0
#@onready var animationTree = $AnimationTree
#@onready var animationState = animationTree.get("parameters/playback")

func _ready():
	position = Vector2(-2000,2000)
	
	parent = get_parent() 
	dash_sound = self.get_node("SFX/Dash")
	child_spawn_sound = self.get_node("SFX/SpawnChild")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	


func _physics_process(_delta):

	speed = BASE_SPEED

	#speed = BASE_SPEED/(escala**SLOW_DOWN) #muda a velocidade pelo tamanho
	
#se apertar esc, ir para menu
	if Input.is_action_just_pressed("ir_para_menu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
#coisas do controle---------------------------------------------------------------------------------------
	if Input.get_last_mouse_velocity().length() > 0.1:
		control_mode = 0
	
	var move_x = Input.get_action_strength("left_stick_r") - Input.get_action_strength("left_stick_l")
	var move_y = Input.get_action_strength("left_stick_d") - Input.get_action_strength("left_stick_u")
	if move_x != 0 or move_y != 0:
		direction_x = move_x
		direction_y = move_y
		
	if move_x > 0 or move_y > 0:
		control_mode = 1
		
	if control_mode == 0:
		cursor.global_position = get_global_mouse_position()
		
	if control_mode == 1:
		if Vector2(direction_x, direction_y).length() != 0:
			cursor.position = 150*Vector2(direction_x, direction_y).normalized() 
#fim coisas do controle---------------------------------------------------------------------------------------	

	#animationTree.set("parameters/Idle1/blend_position", direction)
	#animationTree.set("parameters/Walk1/blend_position", direction)
	
	if move:
		move_and_slide()

		
			
	# input de dar o dash e fazer filho, 
	# só pode ser acionado se tiver filho o suficiente e não está colocando filhos na escola nem em casa
	if Input.is_action_just_pressed("dash_filho") and game_manager.get_trash() >= LIXO_POR_FILHO and game_manager.going_school == false and game_manager.going_home == false:
		fazer_filho()
		child_spawn_sound.play()


		

#Movimentação----------------------------------------------------------------------------------------------
func _on_timer_timeout():
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move
	if control_mode == 0:
		direction = get_global_mouse_position() - position
	else:
	#acima coisas controle
		if Vector2(direction_x, direction_y).length() != 0:
			direction = Vector2(direction_x, direction_y)
			
	direction = direction.normalized()
	
	
	#Animação---------------------------------------------------------------------------------

	tamanho_aux = tamanho + 1

	if tamanho_aux >= 11:
		tamanho_aux = 10
	
	if tamanho_aux >= 11:
		tamanho_aux = 10
	
	var name_aux = ""
	if move:
		if is_dad == false:
			name_aux = "walk_" + get_direction(direction) + "_size" + str(tamanho_aux)
			animation(name_aux)
		else:
			name_aux = "slide_" + get_direction(direction) + "_size" + str(tamanho_aux)
			animation(name_aux)
			dash_sound.play()
	else:
		name_aux = "idle_" + get_direction(direction) + "_size" + str(tamanho_aux)
		animation(name_aux)
	
	#parte do dash, dad_speed serve para os filhos saberem qual a speed atual do pai
	if move:
		if is_dad:
			velocity = SPEED_MULTIPLIER * speed * direction
			dad_speed = SPEED_MULTIPLIER * speed
			is_dad = false
		else:
			velocity = speed * direction
			dad_speed = speed

		time = Time.get_unix_time_from_system()


# parte de sair da escola -------------------------------------------------------------------------
	#verifica se ainda está saindo da escola
	if game_manager.filhos_in_school == 0:
		game_manager.leaving_school = false

	
	#se está saindo da escola
	if game_manager.leaving_school:
		leaving_school()
		
	for child in parent.get_children():
		if child.get_name() != "PC":
			child.animation_logic()

func get_direction(my_direction) -> String:
	var angle = my_direction.angle()
	angle = rad_to_deg(angle)
	#print("angle: " + str(angle))
	if angle >= 135 or angle <= -135:
		return "left"
	elif angle >= 45 and angle <= 135:
		return "down"
	elif angle >= -45 and angle <= 45:
		return "right"
	elif angle >= -135 and angle <= -45:
		return "up"
	else:
		return "down" # This will be returned if the angle is not in any of the specified ranges

func animation(nome_animation):
	animationPlayer.play(nome_animation)

func leaving_school():
	while tamanho <= MAX_TAMANHO and game_manager.filhos_in_school >= 1:
		game_manager.att_school(false) #false pq tá diminuindo
		game_manager.add_trash(LIXO_POR_FILHO)
	
		change_size(true)
	
	#verifica se ainda está saindo da escola
	if game_manager.filhos_in_school == 0:
		game_manager.leaving_school = false
	if game_manager.leaving_school:
		print("tô fazendo filho")
		fazer_filho()
		game_manager.att_school(false) #false pq tá diminuindo

# Função agora é generica e recebe o booleano *aumenta* para definir se diminui ou aumenta o tamanho do PC
#arrumar para não ser quando for divisivel por 3. fazer caso geral pra quando for diminuir tbmm
func change_size(aumenta):
	#tive que botar esse round porque o erro de float tava acumulando 
	#então tava tendo situações que comia 15 lixos mas só conseguia fazer 2 filhos
	if (aumenta):
		if(game_manager.get_trash()/LIXO_POR_FILHO > tamanho):
			var dif_deveria = game_manager.get_trash()/LIXO_POR_FILHO - tamanho
			escala = round(10*(escala + dif_deveria*SIZE_CHANGE))/10
			tamanho += dif_deveria
	else:
		#tamanho antigo
		var tam_antigo = (game_manager.get_lost_trash() + game_manager.get_trash())/LIXO_POR_FILHO
		#tamanho que deveria ter
		var tam_deveria = game_manager.get_trash()/LIXO_POR_FILHO
		#serve para ver quantas vezes vai ter que diminuir de tamanho por ter perdido lixo 
		var quanto_diminuir = tam_antigo - tam_deveria
		escala = max(round(10*(escala - SIZE_CHANGE*quanto_diminuir))/10,1)
		tamanho -= quanto_diminuir


func fazer_filho():

	var filho = 0
	#acabou de fazer um filho, ent no próximo burst irá ser mais veloz
	if game_manager.leaving_school == false:
		is_dad = true
	#aqui é que ele cria os filhos como nodes embaixo do main
	filho = filho_scene.instantiate()
	parent.add_child(filho) 
	
	filho_count += 1
	
	#cada filho tem uma variável número pra saber qual filho que ele éz
	filho.numero = filho_count 
	filho.name = "Filho"
	
	#essa distância é o espaço entre o filho anterior e o filho que ele cria
	var distancia = 30
	if (filho_count ==1): #se for o primeiro filho, essa distância tem que levar em conta o tamanho do pc
		distancia+= 20*(escala - LIXO_POR_FILHO*SIZE_CHANGE)
		
	#ele seta a posição do filho novo como sendo um pouco atrás do último filho
	#aqui o parent.get_child(filho_count - 1) é o último filho

	#acho que esse jeito de acessar os outros nodes não é muito "boa prática", e talvez deixe difícil de editar depois
	#se alguém tiver um jeito melhor pode mudar
	
	filho.position = parent.get_child(filho_count-1).position - distancia*parent.get_child(filho_count-1).direction
	
	#diminui quando faz o filho
	if game_manager.leaving_school == false:
		game_manager.spend_trash()
		change_size(false) #diminui o tamanho




func matar_filho(num):
# Percorre todos os filhos do nó pai (parent)
	for child in parent.get_children():
		if child.get_name() != "PC":
			if child.get_number() == num:
				child.queue_free()
				print("dei free em " + child.get_name())

func obter_filho_count() -> int:
	return filho_count

func obter_lixo_por_filho() -> int:
	return LIXO_POR_FILHO

func zerar_filho_count():
	filho_count = 0

func subtrair_filho_count(mortos):
	filho_count -= mortos
	if (filho_count < 0):
		zerar_filho_count()
	print(filho_count)

@onready var theme = self.get_node("Theme")

func _on_theme_finished():
	theme.play()
	
# acaba jogo e volta para main menu
func _on_end_game_finished():
	get_tree().change_scene_to_file("res://scenes/menu_all/menu_all.tscn")
