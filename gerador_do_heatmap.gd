extends Node

const HEATMAP_SIZE = 16
const DIFICULDADE = 2
var area_scene = preload("res://scenes/areas_mapa.tscn")
var areas = []


var trash = 0

func _ready():
	for i in HEATMAP_SIZE:
		for j in HEATMAP_SIZE:
			areas.append([])
			areas[i].append(area_scene.instantiate())
			add_child(areas[i][j])
			areas[i][j].position = Vector2(300*(i-HEATMAP_SIZE/2), 300*(j-HEATMAP_SIZE/2))
			areas[i][j].level = 0
			
	var A_x = randi_range(round(HEATMAP_SIZE/8),round(HEATMAP_SIZE/3))
	var A_y = randi_range(round(HEATMAP_SIZE/8), round(HEATMAP_SIZE/3))

	var B_x = randi_range(round(2*HEATMAP_SIZE/3),round(7*HEATMAP_SIZE/8))
	var B_y = randi_range(round(2*HEATMAP_SIZE/4), round(7*HEATMAP_SIZE/8))

	cidade(A_x, A_y)

	for i in DIFICULDADE:
		urbanização()
		
	ajuste()
	
	cidade(B_x,B_y)
	for i in DIFICULDADE:
		urbanização()
	ajuste()
		

		
	

func cidade(x, y):
	areas[x][y].level = 6
	areas[x+1][y].level = 6	
	areas[x][y+1].level = 6	
	areas[x+1][y+1].level = 6	
	
func urbanização():
	
	var pontos_para_aumentar = []
					
	for i in HEATMAP_SIZE:
		for j in HEATMAP_SIZE:
			if is_near(i,j,6) and areas[i][j].level == 0:
				pontos_para_aumentar.append([i,j])
				
	for ponto in pontos_para_aumentar:
				var rand = randi_range(1,2)
				if rand == 1:
					areas[ponto[0]][ponto[1]].level = 6
				else:
					areas[ponto[0]][ponto[1]].level = 5

func ajuste():
		for i in HEATMAP_SIZE:
			for j in HEATMAP_SIZE:
				if areas[i][j].level > 3:
					areas[i][j].level -= 3
		for i in HEATMAP_SIZE:
			for j in HEATMAP_SIZE:
				if areas[i][j].level == 0 and is_near(i,j,3):
					areas[i][j].level = 2
		for i in HEATMAP_SIZE:
			for j in HEATMAP_SIZE:
				if areas[i][j].level == 0 and is_near(i,j,2):
					areas[i][j].level = 1
				

func is_near(x,y, nivel):
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if (x+i) >= 0 and (x + i) < HEATMAP_SIZE and (y+j) >= 0 and (y + j) < HEATMAP_SIZE:
				if areas[x+i][y+j].level == nivel:
					return true
				
	return false


