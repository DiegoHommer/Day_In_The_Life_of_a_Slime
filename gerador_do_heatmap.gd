extends Node

const HEATMAP_SIZE = 16
const DIFICULDADE = 2
const TOTAL_LIXO = 120
var lixo_scene = preload("res://scenes/trash.tscn")
var area_scene = preload("res://scenes/areas_mapa.tscn")
var areas = []


var trash = 0

func _ready():
	for i in HEATMAP_SIZE:
		for j in HEATMAP_SIZE:
			areas.append([])
			areas[i].append(area_scene.instantiate())
			add_child(areas[i][j])
			areas[i][j].position = Vector2(320*(i-HEATMAP_SIZE/2), 320*(j-HEATMAP_SIZE/2))
			areas[i][j].level = 0
			
	var A_x = randi_range(2,5)
	var A_y = randi_range(2, 5)

	var B_x = randi_range(11,14)
	var B_y = randi_range(11,14)

	cidade(A_x, A_y)

	for i in DIFICULDADE:
		urbanização()
		
	ajuste()
	
	cidade(B_x,B_y)
	for i in DIFICULDADE:
		urbanização()
	ajuste()
		
	#garante que os cantos do spawn e da cidade são seguros
	for i in 3:
		for j in 3:
			areas[i][HEATMAP_SIZE - 1 - j].level = 0
			areas[HEATMAP_SIZE - i - 1][j].level = 0
			
		
	#fazer os lixos------------------------------------------------------------	
	var quantos_lixos = 0
	
	#primeiro ele garante que cada quadrado vermelho tem pelo menos 1 lixo
	for i in HEATMAP_SIZE:
		for j in HEATMAP_SIZE:
			if areas[i][j].level == 3:
				var lixo = lixo_scene.instantiate()
				add_child(lixo) 
				lixo.position = areas[i][j].position + Vector2(randi_range(0,320), randi_range(0,320))
				quantos_lixos +=1
	
	#o resto é mais aleatório
	while(quantos_lixos < TOTAL_LIXO):
		#sorteia uma posição
		var rand_x = randi_range(0,HEATMAP_SIZE - 1)
		var rand_y = randi_range(0,HEATMAP_SIZE - 1)
		#a chance de criar um lixo na posição sorteada depende do heat da área da posição
		if (randf_range(0,1)*(areas[rand_x][rand_y].level+1)>0.95):
			var lixo = lixo_scene.instantiate()
			add_child(lixo) 
			lixo.position = areas[rand_x][rand_y].position + Vector2(randi_range(0,320), randi_range(0,320))
			quantos_lixos +=1
		
	

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


