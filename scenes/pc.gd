extends CharacterBody2D


@export var speed = 250.0
var move = true
var direction = Vector2(0,0)

var filho_scene = preload("res://filho.tscn")
var filho = 0
var filho_count = 0
var parent = ""
var tempo = 0


func _ready():
	parent = get_parent() 

func _physics_process(delta):
	if move:
		move_and_slide()
		
	if Input.is_action_just_pressed("ui_accept"):
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
	$Collision.scale.x += 1
	$Collision.scale.y += 1
	$Polygon2D.scale.x += 1
	$Polygon2D.scale.y += 1

	
func fazer_filho():
	#aqui é que ele cria os filhos como nodes embaixo do main
	filho = filho_scene.instantiate()
	parent.add_child(filho) 
	
	filho_count += 1
	
	#cada filho tem uma variável número pra saber qual filho que ele é
	filho.numero = filho_count 
	
	#ele seta a posição do filho novo como sendo um pouco atrás do último filho
	#aqui o parent.get_child(filho_count - 1) é o último filho
	#acho que esse jeito de acessar os outros nodes não é muito "boa prática", e talvez deixe difícil de editar depois
	#se alguém tiver um jeito melhor pode mudar
	filho.position = parent.get_child(filho_count-1).position - 50*parent.get_child(filho_count-1).direction


