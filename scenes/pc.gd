extends CharacterBody2D

#movimento------------------------------------------------------------------------------
const BASE_SPEED = 250
@export var speed = BASE_SPEED
var move = true
var direction = Vector2(0,0)

#tamanho------------------------------------------------------------------------------
const SIZE_CHANGE = 0.2
var escala = 1
#esse parâmetro controla o quão forte é a desaceleração dele quando ele cresce
#se é 1, ele fica duas vezes mais lento quando tá duas vezes maior. Botei 0.5 porque parecia melhor, mas dá pra mudar
const SLOW_DOWN = 0.5

#filhos-------------------------------------------------------------------------------
var filho_scene = preload("res://scenes/filho.tscn")
var filho_count = 0
const LIXO_POR_FILHO = 5
var parent = ""
var tempo = 0

#lixo-------------------------------------------------------------------------------
#queremos 
@onready var game_manager = %GameManager


func _ready():
	position = Vector2(-1800,1800)
	parent = get_parent() 


func _physics_process(delta):
	speed = BASE_SPEED/(escala**SLOW_DOWN) #muda a velocidade pelo tamanho
	
	if move:
		move_and_slide()
		
	#botei que ele pode fazer um filho a cada 5 lixos comidos, mas dá pra mudar isso
	#(mudei a condição para estar atrelado aos lixos em si, não a escala)
	if Input.is_action_just_pressed("ui_accept") and game_manager.get_trash() >= LIXO_POR_FILHO:
		fazer_filho()
		game_manager.att_trash(LIXO_POR_FILHO)


func _on_timer_timeout():
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move
	direction = get_global_mouse_position() - position
	
	if direction.length() < 20: #se ele tiver muito perto do mouse ele fica parado
		direction = Vector2(0,0)
	direction = direction.normalized()
	velocity = speed * direction


# Função agora é generica e recebe o booleano *aumenta* para definir se diminui ou aumenta o tamanho do PC
func change_size(aumenta):
	#tive que botar esse round porque o erro de float tava acumulando 
	#então tava tendo situações que comia 15 lixos mas só conseguia fazer 2 filhos
	if (aumenta):
		escala = round(10*(escala + SIZE_CHANGE))/10
	else:
		escala = round(10*(escala - SIZE_CHANGE*game_manager.get_lost_trash()))/10
		
	$Collision.scale.x = escala
	$Collision.scale.y = escala
	$Polygon2D.scale.x = escala
	$Polygon2D.scale.y = escala


func fazer_filho():
	var filho = 0
	
	#aqui é que ele cria os filhos como nodes embaixo do main
	filho = filho_scene.instantiate()
	parent.add_child(filho) 
	
	filho_count += 1
	
	#cada filho tem uma variável número pra saber qual filho que ele é
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
	escala -=SIZE_CHANGE*LIXO_POR_FILHO
	$Collision.scale.x = escala
	$Collision.scale.y = escala
	$Polygon2D.scale.x = escala
	$Polygon2D.scale.y = escala


func matar_filhos():
# Percorre todos os filhos do nó pai (parent)
	for child in parent.get_children():
		var teste = child.get_name()
		if child.get_name() != "PC":
			child.queue_free()


func obter_filho_count() -> int:
	return filho_count


func zerar_filho_count():
	filho_count = 0


# Quando imunidade do player acaba, retorna a "sprite" para sua versão original
@onready var player_sprite = %PC/Polygon2D
func _on_immunity_timer_timeout():
	player_sprite.set_color(Color(255,255,255,255))
