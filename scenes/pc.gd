extends CharacterBody2D

@onready var cursor = %cursor
var direction_x 
var direction_y

#movimento------------------------------------------------------------------------------
const BASE_SPEED = 250
#quão mais rápido é com o dash
const SPEED_MULTIPLIER = 2.5
@export var speed = BASE_SPEED
var move = true
var direction = Vector2(0,0)
#variável para dizer se acabou de fazer um filho (não se possui filhos atualmente) 
#se for pai irá dar o dash (variável apenas para controlar o dash)
var is_dad = false

var dad_speed = 0


var control_mode = 1
var stick_left = 0
var stick_right = 0



#tamanho------------------------------------------------------------------------------
const SIZE_CHANGE = 0.2
var escala = 1
#esse parâmetro controla o quão forte é a desaceleração dele quando ele cresce
#se é 1, ele fica duas vezes mais lento quando tá duas vezes maior. Botei 0.5 porque parecia melhor, mas dá pra mudar
const SLOW_DOWN = 0.5

#filhos-------------------------------------------------------------------------------
var filho_scene = preload("res://scenes/filho.tscn")
var filho_count = 0
const LIXO_POR_FILHO = 3
var parent = ""
var tempo = 0

#lixo-------------------------------------------------------------------------------
@onready var game_manager = %GameManager


func _ready():
	position = Vector2(-2000,2000)
	parent = get_parent() 
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	


func _physics_process(_delta):
	
	if Input.get_last_mouse_velocity().length() > 0.1:
		control_mode = 0
	
	direction_x = Input.get_action_strength("left_stick_r") - Input.get_action_strength("left_stick_l")
	direction_y = Input.get_action_strength("left_stick_d") - Input.get_action_strength("left_stick_u")
		
	if direction_x > 0 or direction_y > 0:
		control_mode = 1
		
	if control_mode == 0:
		cursor.global_position = get_global_mouse_position()
		
	if control_mode == 1:
		if Vector2(direction_x, direction_y).length() != 0:
			cursor.position = 150*Vector2(direction_x, direction_y).normalized() 
		
		
	speed = BASE_SPEED/(escala**SLOW_DOWN) #muda a velocidade pelo tamanho
	
	if Input.is_action_just_pressed("ir_para_menu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	if move:
		move_and_slide()
		
	#botei que ele pode fazer um filho a cada 5 lixos comidos, mas dá pra mudar isso
	#(mudei a condição para estar atrelado aos lixos em si, não a escala)
	if Input.is_action_just_pressed("dash_filho") and game_manager.get_trash() >= LIXO_POR_FILHO:
		fazer_filho()
		game_manager.att_trash(LIXO_POR_FILHO)
		


func _on_timer_timeout():
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move
	if control_mode == 0:
		direction = get_global_mouse_position() - position
	
	else:
		if Vector2(direction_x, direction_y).length() != 0:
			direction = Vector2(direction_x, direction_y)
		
	
	direction = direction.normalized()
	
	if move:
		if is_dad:
			velocity = SPEED_MULTIPLIER * speed * direction
			dad_speed = SPEED_MULTIPLIER * speed
			is_dad = false
		else:
			velocity = speed * direction
			dad_speed = speed
	


# Função agora é generica e recebe o booleano *aumenta* para definir se diminui ou aumenta o tamanho do PC
func change_size(aumenta):
	if (game_manager.get_trash() % LIXO_POR_FILHO) == 0:
		#tive que botar esse round porque o erro de float tava acumulando 
		#então tava tendo situações que comia 15 lixos mas só conseguia fazer 2 filhos
		if (aumenta):
			escala = round(10*(escala + SIZE_CHANGE))/10
		else:
			escala = max(round(10*(escala - SIZE_CHANGE*game_manager.get_lost_trash()))/10,1)
			
		$Collision.scale.x = escala
		$Collision.scale.y = escala
		$Polygon2D.scale.x = escala
		$Polygon2D.scale.y = escala


func fazer_filho():
	var filho = 0
	#acabou de fazer um filho, ent no próximo burst irá ser mais veloz
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
	escala -=SIZE_CHANGE
	$Collision.scale.x = escala
	$Collision.scale.y = escala
	$Polygon2D.scale.x = escala
	$Polygon2D.scale.y = escala


func matar_filhos():
# Percorre todos os filhos do nó pai (parent)
	for child in parent.get_children():
		if child.get_name() != "PC":
			child.queue_free()


func obter_filho_count() -> int:
	return filho_count

func obter_lixo_por_filho() -> int:
	return LIXO_POR_FILHO

func zerar_filho_count():
	filho_count = 0

func subtrair_filho_count(mortos):
	filho_count -= mortos
	print(filho_count)


# Quando imunidade do player acaba, retorna a "sprite" para sua versão original
@onready var player_sprite = %PC/Polygon2D

func _on_immunity_timer_timeout():
	player_sprite.set_color(Color(255,255,255,255))
