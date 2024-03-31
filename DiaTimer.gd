extends Node
@onready var tempo = $Panel3/Tempo
@onready var tempo_dia = $Panel3/TempoDia
@onready var volta_casa = $Panel3/VoltaCasa

var dia = true
# Called when the node enters the scene tree for the first time.
func _ready():

	tempo_dia.start()

func time_left_to_live():
	var time_left = tempo_dia.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]	

func time_left_to_go_back():
	var time_left = volta_casa.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dia:
		tempo.text = "%02d:%02d" % time_left_to_live()
	else:
		tempo.text = "%02d:%02d" % time_left_to_go_back()



func _on_tempo_dia_timeout():
	volta_casa.start()
	dia = false
	
