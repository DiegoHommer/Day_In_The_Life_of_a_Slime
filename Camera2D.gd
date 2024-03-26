extends Camera2D

var direction = Vector2(0,0)

#Como o pc tá se mexeno com o move_and_slide() que é pronto do Godot, a velocidade dele tem que ser mais 
var speed_multiplier = 0.00002
@onready var pc = %PC
var speed = 0
var velocity = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	speed = pc.speed*0.00002


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = pc.position - position
	#direction = direction.normalized()
	velocity = speed*direction
	position += velocity
