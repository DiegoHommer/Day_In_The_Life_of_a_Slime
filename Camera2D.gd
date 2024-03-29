extends Camera2D

var direction = Vector2(0,0)

#Pra fazer ele ficar mais rápido quando o player sai do centro, eu não tô normalizando a posição
#Além disso, a velocidade do pc tem que ser maior do que a velocidade "real" dele pelo jeito como
#o move_and_slide() funciona
#por isso a velocidade da câmera tem que ser a do pc vezes um multiplicador bem pequeno
var speed_multiplier = 0.00002
@onready var pc = %PC
var speed = 0
var velocity = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	speed = pc.speed*speed_multiplier


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	direction = pc.position - position
	#direction = direction.normalized()
	velocity = speed*direction
	position += velocity
