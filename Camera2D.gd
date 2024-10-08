extends Camera2D

#quanto maior isso for maior o efeito de aceleração da câmera  quando o player sai de perto do centro
const CAMERA_EXPOENTE = 0.05 

var direction = Vector2(0,0)
var is_zoomed = false

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
	position = pc.position
	speed = pc.speed*speed_multiplier


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	direction = pc.position - position
	direction*=direction.length()**(CAMERA_EXPOENTE)
	#direction = direction.normalized()
	velocity = speed*direction
	position += velocity
	
	if Input.is_action_just_pressed("zoom"): #dá zoom no Z
		is_zoomed = not is_zoomed
		
	if is_zoomed:
		zoom = Vector2(0.12,0.12)
	else:
		zoom = Vector2(0.5,0.5)
