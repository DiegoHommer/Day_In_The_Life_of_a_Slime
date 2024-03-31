extends Area2D

var level = 0
var area = get_child(0)
var color = Color()
var green = Color(0,1,0,0.5)
var yellow = Color(0.9,0.9,0.2,0.5)
var orange = Color(1,0.5,0,0.5)
var red = Color(1,0,0,0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match level: 
		0:
			color = green
		1:
			color = yellow
		2:
			color = orange
		3:
			color = red
