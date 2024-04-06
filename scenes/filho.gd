extends CharacterBody2D
@onready var game_manager = ""


var parent = ""
var pc = ""
@onready var sprite = self.get_node("Sprite2D")
@onready var collision = self.get_node("Collision")
var speed = 250
var numero = 0 #esse numero é setado pelo pc quando ele cria o filho. Diz se ele é o primeiro, segundo, etc
var move = true
var dead = false
var being_born = true
var direction = Vector2(0,0)
var escala = 1
var mult_dist = 1
var death_sound = ""

const SCHOOL_POSITION = Vector2(2000, -2000)
#const SCHOOL_POSITION = Vector2(-1600,2000)

const HOME_POSITION = Vector2(-2300,2300)

func _ready():
	parent = get_parent() #"parent" aqui é o parent node (que é o main por enquanto) e não o pc
	pc = parent.get_child(0)
	#fiz isso porque os filhos spawnados não tavam achando o GameManager do jeito que tava
	owner = get_parent().owner  
	game_manager = %GameManager
	sprite.animation = "birth"
	sprite.play()
	death_sound = parent.get_node("PC/SFX/DeathChild")
	

func die():
	sprite.animation = "death"
	sprite.play()
	dead = true
	death_sound.play()

func animation_logic():
	if ((not dead) and (not being_born)):
		var direction_angle = direction.angle()
		var is_dashing = "normal"
		
		if (pc.is_dad):
			is_dashing = "dash"
			
		if (cos(direction_angle) > (PI/4)):
			sprite.animation = "right_" + is_dashing
		elif (cos(direction_angle) < (-PI/4)):
			sprite.animation = "left_" + is_dashing
		elif (sin(direction_angle) < 0):
			sprite.animation = "up_" + is_dashing
		else: 
			sprite.animation = "down_" + is_dashing
		sprite.play()

	
	
	
func _physics_process(_delta):
	if (not dead):
		move = pc.move
		speed = pc.speed
		
		if move and pc.direction != Vector2(0,0) and pc.obter_filho_count() != 0: #
			
			if game_manager.going_school:
				direction = SCHOOL_POSITION - position
			elif game_manager.going_home:
				direction = HOME_POSITION - position
			else:
				#isso serve pra ajustar o ponto que ele segue dependendo do tamanho do pc 
				mult_dist = parent.get_child(numero-1).escala 
				
				#a ideia é que ele segue um ponto que tá um pouco atrás do filho anterior (ou pc, se for o primeiro filho)
				#(aqui, parent.get_child(numero-1) é o filho anterior)
				#eu tentei fazer ele seguir diretamente o filho anterior, mas daí eles se amontoavam
				direction = (parent.get_child(numero-1).position-(100 + mult_dist)*parent.get_child(numero-1).direction) - position
				
			#
			direction = direction.normalized()
			velocity = pc.dad_speed * direction
			
			move_and_slide()


func get_number() -> int:
	return numero

func _on_sprite_2d_animation_finished():
	if (sprite.animation == "birth"):
		being_born = false
		
	if (sprite.animation == "death"):
		self.queue_free()
		parent.remove_child(self)
