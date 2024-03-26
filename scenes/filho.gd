extends CharacterBody2D

var parent = ""
var pc = ""
var speed = 250
var numero = 0 #esse numero é setado pelo pc quando ele cria o filho. Diz se ele é o primeiro, segundo, etc
var move = true
var direction = Vector2(0,0)
var escala = 1
var mult_dist = 1

func _ready():
	parent = get_parent() #"parent" aqui é o parent node (que é o main por enquanto) e não o pc
	pc = parent.get_child(0)

func _physics_process(delta):
	move = pc.move
	speed = pc.speed
	
	if move and pc.direction != Vector2(0,0): #
		
		#isso serve pra ajustar o ponto que ele segue dependendo do tamanho do pc 
		mult_dist = parent.get_child(numero-1).escala 
		
		#a ideia é que ele segue um ponto que tá um pouco atrás do filho anterior (ou pc, se for o primeiro filho)
		#(aqui, parent.get_child(numero-1) é o filho anterior)
		#eu tentei fazer ele seguir diretamente o filho anterior, mas daí eles se amontoavam
		direction = (parent.get_child(numero-1).position-30*mult_dist*parent.get_child(numero-1).direction) - position
		direction = direction.normalized()
		velocity = speed*direction
		move_and_slide()
		


