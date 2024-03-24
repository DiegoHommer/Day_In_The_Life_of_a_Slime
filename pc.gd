extends CharacterBody2D


@export var speed = 250.0
var move = true

var direction = Vector2(0,0)




func _physics_process(delta):
	if move:
		move_and_slide()



func _on_timer_timeout():
	#a cada 0.5 segundo ele muda entre parado e se mexendo (move = false ou move = true), e decide na direção
	move = not move
	direction = get_global_mouse_position() - position
	
	if direction.length() < 10: #se ele tiver muito perto do mouse ele fica parado
		direction = Vector2(0,0)
	velocity = speed * direction.normalized()
