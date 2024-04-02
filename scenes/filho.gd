extends CharacterBody2D
@onready var game_manager = ""


var parent = ""
var pc = ""
var speed = 250
var numero = 0 #esse numero é setado pelo pc quando ele cria o filho. Diz se ele é o primeiro, segundo, etc
var move = true
var direction = Vector2(0,0)
var escala = 1
var mult_dist = 1

#var school_position = Vector2(2000, -2000)
var school_position = Vector2(-1600,2000)

func _ready():
	parent = get_parent() #"parent" aqui é o parent node (que é o main por enquanto) e não o pc
	pc = parent.get_child(0)
	
	#fiz isso porque os filhos spawnados não tavam achando o GameManager do jeito que tava
	owner = get_parent().owner  
	game_manager = %GameManager

func _physics_process(_delta):
	move = pc.move
	speed = pc.speed
	
	if move and pc.direction != Vector2(0,0) and pc.obter_filho_count() != 0: #
		
		if game_manager.going_school:
			direction = school_position - position
		else:
			#isso serve pra ajustar o ponto que ele segue dependendo do tamanho do pc 
			mult_dist = parent.get_child(numero-1).escala 
			
			#a ideia é que ele segue um ponto que tá um pouco atrás do filho anterior (ou pc, se for o primeiro filho)
			#(aqui, parent.get_child(numero-1) é o filho anterior)
			#eu tentei fazer ele seguir diretamente o filho anterior, mas daí eles se amontoavam
			direction = (parent.get_child(numero-1).position-(10 + 20*mult_dist)*parent.get_child(numero-1).direction) - position
			
		#
		direction = direction.normalized()
		
		velocity = pc.dad_speed * direction
		
		move_and_slide()


func get_number() -> int:
	return numero


