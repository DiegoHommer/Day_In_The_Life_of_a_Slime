extends CharacterBody2D

var parent = ""
var pc = ""
var speed = 250
var numero = 0 #esse numero vai ser setado pelo pc quando ele criar o filho. É 1 se é o primeiro, 2 se é o seugundo etc
var move = true
var direction = Vector2(0,0)

func _ready():
	parent = get_parent() #"parent" aqui é o parent node (que é o main por enquanto) e não o pc
	pc = parent.get_child(0)

func _physics_process(delta):
	move = pc.move
	speed = pc.speed
	
	if move and pc.direction != Vector2(0,0): #
		
		#a ideia é que ele segue um ponto que tá um pouco atrás do filho anterior
		#(aqui, parent.get_child(numero-1) é o filho anterior)
		#eu tentei fazer ele seguir diretamente o filho anterior, mas daí eles se amontoavam
		direction = (parent.get_child(numero-1).position-30*parent.get_child(numero-1).direction) - position
		direction = direction.normalized()
		velocity = speed*direction
		move_and_slide()
		


