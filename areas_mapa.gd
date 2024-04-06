extends Area2D

var level = 0
const FLOOR_SPRITES = "res://Assets/world/floor/"
@onready var area = get_child(0)
@onready var floor_sprite_path = self.get_node("Sprite2D")
var color = Color()
var green = Color(0,1,0,0.5)
var yellow = Color(0.9,0.9,0.2,0.5)
var orange = Color(1,0.5,0,0.5)
var red = Color(1,0,0,0.5)

# Called when the node enters the scene tree for the first time.
func paint_tile():
	match level: 
		0:
			var floor_sprite = load(FLOOR_SPRITES + "verde" + str(randi_range(1,12)) + ".png")
			floor_sprite_path.set_texture(floor_sprite)
		1:
			var floor_sprite = load(FLOOR_SPRITES + "amarelo" + str(randi_range(1,4)) + ".png")
			floor_sprite_path.set_texture(floor_sprite)
		2:
			var floor_sprite = load(FLOOR_SPRITES + "laranja" + str(randi_range(1,4)) + ".png")
			floor_sprite_path.set_texture(floor_sprite)
		3:
			var floor_sprite = load(FLOOR_SPRITES + "vermelho" + str(randi_range(1,4)) + ".png")
			floor_sprite_path.set_texture(floor_sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match level: 
		0:
			color = green
		1:
			color = yellow
		2:
			color = orange
		3:
			color = red
