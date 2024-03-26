extends CharacterBody2D

#movimento------------------------------------------------------------------------------
const BASE_SPEED = 250
@export var speed = BASE_SPEED
var move = true
var direction = Vector2(0,0)

#tamanho------------------------------------------------------------------------------
const SIZE_CHANGE = 0.1
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


func _ready():
	parent = get_parent() 

func _physics_process(delta):
	speed = BASE_SPEED/(escala**SLOW_DOWN) #muda a velocidade pelo tamanho
	
	if move:
		move_and_slide()
		
	#botei que ele pode fazer um filho a cada 5 lixos comidos, mas dá pra mudar isso
	if Input.is_action_just_pressed("ui_accept") and escala >= 1+SIZE_CHANGE*LIXO_POR_FILHO:
		fazer_filho()

func _on_timer_timeout():
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move
	direction = get_global_mouse_position() - position
	
	if direction.length() < 20: #se ele tiver muito perto do mouse ele fica parado
		direction = Vector2(0,0)
	direction = direction.normalized()
	velocity = speed * direction
	
func get_bigger():
	#tive que botar esse round porque o erro de float tava acumulando 
	#então tava tendo situações que comia 15 lixos mas só conseguia fazer 2 filhos
	escala = round(10*(escala + SIZE_CHANGE))/10
	$Collision.scale.x = escala
	$Collision.scale.y =escala
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
	
	#essa distância é o espaço entre o filho anterior e o filho que ele cria
	var distancia = 30
	if (filho_count ==1): #se for o primeiro filho, essa distância tem que levar em conta o tamanho do pc
		distancia+= 20*(escala - LIXO_POR_FILHO*SIZE_CHANGE)
		
	#ele seta a posição do filho novo como sendo um pouco atrás do último filho
	#aqui o parent.get_child(filho_count - 1) é o último filho
	filho.position = parent.get_child(filho_count-1).position - distancia*parent.get_child(filho_count-1).direction
	
	#diminui quando faz o filho
	escala -=SIZE_CHANGE*LIXO_POR_FILHO
	$Collision.scale.x =escala
	$Collision.scale.y = escala
	$Polygon2D.scale.x = escala
	$Polygon2D.scale.y = escala
	


