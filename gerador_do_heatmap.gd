extends Node

const HEATMAP_SIZE = 16
const DIFICULDADE = 2
const TOTAL_LIXO = 120
const TOTAL_ARVORES = 40
const TOTAL_INIMIGOS = DIFICULDADE * 5
const TOTAL_ARQUEIROS = 20
const TREE_SPRITES = "res://assets/world/trees/tree"
const TRASH_SPRITES = "res://assets/world/trash/trash"
var lixo_scene = preload("res://scenes/world/trash.tscn")
var area_scene = preload("res://scenes/world/areas_mapa.tscn")
var arvore_scene = preload("res://scenes/world/tree.tscn")
var obstacle_scene = preload("res://scenes/world/obstacle.tscn")
var trash_scene = preload("res://scenes/world/trash.tscn")
var enemy_scene = preload("res://scenes/enemies/enemy.tscn")
var areas = []
var quantas_arvores = 0
var lista_arvores = []
var lista_inimigos = []


var trash = 0

func _ready():
	for i in HEATMAP_SIZE:
		for j in HEATMAP_SIZE:
			areas.append([])
			areas[i].append(area_scene.instantiate())
			add_child(areas[i][j])
			areas[i][j].position = Vector2(320*(i-float(HEATMAP_SIZE)/2), 320*(j-float(HEATMAP_SIZE)/2))
			areas[i][j].level = 0
			
	var A_x = randi_range(1,4)
	var A_y = randi_range(1, 4)

	var B_x = randi_range(HEATMAP_SIZE - 5,HEATMAP_SIZE - 2)
	var B_y = randi_range(HEATMAP_SIZE - 5,HEATMAP_SIZE - 2)

	cidade(A_x, A_y)

	for i in DIFICULDADE:
		urbanização()
		
	ajuste()
	
	cidade(B_x,B_y)
	for i in DIFICULDADE:
		urbanização()
	ajuste()
		
	#garante que os cantos do spawn e da escola são seguros
	for i in 3:
		for j in 3:
			areas[i][HEATMAP_SIZE - 1 - j].level = 0
			areas[HEATMAP_SIZE - i - 1][j].level = 0
			
	for i in 16:
		for j in  16:
			areas[i][j].paint_tile()
			
		
	gerar_lixo()
	gerar_arvores()
	gerar_inimigos()
	

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
				

func is_near(x,y, nivel): #confere se algum quadrado adjacente tem level==nivel
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if (x+i) >= 0 and (x + i) < HEATMAP_SIZE and (y+j) >= 0 and (y + j) < HEATMAP_SIZE:
				if areas[x+i][y+j].level == nivel:
					return true
				
	return false
	
func gerar_lixo():
	var quantos_lixos = 0
	
	#primeiro ele garante que cada quadrado vermelho tem pelo menos 1 lixo
	for i in HEATMAP_SIZE:
		for j in HEATMAP_SIZE:
			if areas[i][j].level == 3:
				var lixo = lixo_scene.instantiate()
				add_child(lixo)
				var trash_sprite_path = lixo.get_node("Sprite2D")
				var trash_sprite = load(TRASH_SPRITES + str(randi_range(2,8)) + ".png")
				trash_sprite_path.set_texture(trash_sprite)

				lixo.position = areas[i][j].position + Vector2(randi_range(0,320), randi_range(0,320))
				quantos_lixos +=1
	
	#o resto é mais aleatório
	while(quantos_lixos < TOTAL_LIXO):
		#sorteia uma posição
		var rand_x = randi_range(0,HEATMAP_SIZE - 1)
		var rand_y = randi_range(0,HEATMAP_SIZE - 1)
		#a chance de criar um lixo na posição sorteada depende do heat da área da posição
		if (randf_range(0,1)*(areas[rand_x][rand_y].level+1)>0.92):
			var lixo = lixo_scene.instantiate()
			add_child(lixo)
			var trash_sprite_path = lixo.get_node("Sprite2D")
			var trash_sprite = load(TRASH_SPRITES + str(randi_range(2,8)) + ".png")
			trash_sprite_path.set_texture(trash_sprite)
			lixo.position = areas[rand_x][rand_y].position + Vector2(randi_range(0,320), randi_range(0,320))
			quantos_lixos +=1
		
func gerar_arvores():
	var arvore = ""
	while(quantas_arvores < TOTAL_ARVORES):
		#sorteia uma posição
		var rand_x = randi_range(0,HEATMAP_SIZE - 1)
		var rand_y = randi_range(0,HEATMAP_SIZE - 1)
		#se a posição for verde e não for no canto da escola, ele cria uma árvore
		if areas[rand_x][rand_y].level == 0 and not (rand_x > HEATMAP_SIZE - 3 and rand_y < 3) and not (rand_x < 3 and rand_y > HEATMAP_SIZE - 3):
			var sorteio
			if (randi_range(1,2) == 1):
				arvore = arvore_scene.instantiate()
				sorteio = randi_range(1,6)
			else:
				arvore = obstacle_scene.instantiate()
				sorteio = randi_range(7,12)
				
			add_child(arvore) 
			var arvore_sprite_path = arvore.get_node("Sprite2D")
			var arvore_sprite = load(TREE_SPRITES + str(sorteio) + ".png")
			arvore_sprite_path.set_texture(arvore_sprite)
				
			
			
			var respawn = true
			
			while respawn: #se a arvore spawnar muito perto de outra ele respawna
				respawn = false
				arvore.position = areas[rand_x][rand_y].position + Vector2(randi_range(30,300), randi_range(30,300))
				for outra_arvore in lista_arvores:
					if (outra_arvore.position - arvore.position).length() < 80:
						respawn = true
						
			lista_arvores.append(arvore)
			quantas_arvores +=1
			
func gerar_inimigos():
	var quantos_inimigos = 0
	while( quantos_inimigos < (TOTAL_INIMIGOS - TOTAL_ARQUEIROS)):
		#sorteia uma posição
		var rand_x = randi_range(0,HEATMAP_SIZE - 1)
		var rand_y = randi_range(0,HEATMAP_SIZE - 1)
		#a chance de criar um inimigo na posição sorteada depende do heat da área da posição
		if (randf_range(0,1)*(areas[rand_x][rand_y].level+1)>0.92) and not (rand_x > HEATMAP_SIZE - 3 and rand_y < 3) and not (rand_x < 3 and rand_y > HEATMAP_SIZE - 3):
			var enemy = enemy_scene.instantiate()
			enemy.enemy_type = "Warrior"
			add_child(enemy) 
			var respawn = true
			while (respawn):
				respawn = false
				enemy.position = areas[rand_x][rand_y].position + Vector2(randi_range(0,320), randi_range(0,320))
				for arvore in lista_arvores:
					if (arvore.position - enemy.position).length() < 80:
						respawn = true
				for outro_inimigo in lista_inimigos:
					if (outro_inimigo.position - enemy.position).length() < 80:
						respawn = true
			lista_inimigos.append(enemy)
			quantos_inimigos +=1
	
	while( quantos_inimigos < TOTAL_INIMIGOS):
		#sorteia uma posição
		var rand_x = randi_range(0,HEATMAP_SIZE - 1)
		var rand_y = randi_range(0,HEATMAP_SIZE - 1)
		#a chance de criar um inimigo na posição sorteada depende do heat da área da posição
		if (randf_range(0,1)*(areas[rand_x][rand_y].level+1)<0.92) and not (rand_x > HEATMAP_SIZE - 4 and rand_y < 4) and not (rand_x < 4 and rand_y > HEATMAP_SIZE - 4):
			var enemy = enemy_scene.instantiate()
			enemy.enemy_type = "Archer"
			add_child(enemy) 
			var respawn = true
			while (respawn):
				respawn = false
				enemy.position = areas[rand_x][rand_y].position + Vector2(randi_range(0,320), randi_range(0,320))
				for arvore in lista_arvores:
					if (arvore.position - enemy.position).length() < 80:
						respawn = true
				for outro_inimigo in lista_inimigos:
					if (outro_inimigo.position - enemy.position).length() < 80:
						respawn = true
			lista_inimigos.append(enemy)
			quantos_inimigos +=1


