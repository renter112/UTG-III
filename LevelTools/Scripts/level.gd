extends Node2D

var baseGrid = Vector2(0,0)
var playerPos = Vector2(0,0)
var blockList = []
var blockList2 = []
var enemyDetails = []
var enemies = 0
var scaler = 64 as int
var timer = 0 

var pause_menu = preload("res://Menus/pause_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	parseXML()
	Global.attempts_taken += 1
	Global.shots_taken = 0
	$cam.zoom = Vector2(min(1600/(baseGrid.x*scaler),896/(baseGrid.y*scaler)),min(1600/(baseGrid.x*scaler),896/(baseGrid.y*scaler)))
	build_grid()
	build_objects()
	build_enemies()
	Global.enemies = enemies
	pass # Replace with function body.

func parseXML():
	var parser = XMLParser.new()
	var level = Global.get_level()
	if Global.adventureMode :
		parser.open("res://LevelTools/AdventureLevels/"+str(level)+".xml")
	elif Global.custom_level_on :
		parser.open("res://LevelTools/AdventureLevels/"+str(level)+".xml")
	else:
		parser.open("res://LevelTools/levels/"+str(level))
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var att_dict = {}
			for idx in range(parser.get_attribute_count()):
				att_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if node_name == "grid":
				baseGrid = Vector2(att_dict["x"] as int,att_dict["y"] as int)
			elif node_name == "coord":
				var type = 0
				match att_dict["type"]:
					"hole":
						type = 2
					"block":
						type = 3
					"breakable":
						type = 4
					"finish":
						$finish_button.position = Vector2i(att_dict["x"] as int *scaler + scaler/2, att_dict["y"] as int *scaler + scaler/2)
						type = -1
					_:
						type = -1
				if type != -1:
					blockList.append(Vector3(att_dict["x"] as int,att_dict["y"] as int,type))
			elif node_name == "player":
				if att_dict["type"] == "p1":
					$tank_hull.position = Vector2(att_dict["x"] as int * scaler + scaler/2,att_dict["y"] as int *scaler + scaler/2)
				#if att_dict["dir"] == "u":
					#$tank_hull.rotation = -90
				#elif att_dict["dir"] == "d":
					#$tank_hull.rotation = 90
				#elif att_dict["dir"] == "l":
					#$tank_hull.rotation = 180
			elif node_name == "turret":
				enemyDetails.push_back( [att_dict["type"],att_dict["x"] as float, att_dict["y"] as float, 1] )
			elif node_name == "tank":
				enemyDetails.push_back( [ att_dict["type"], att_dict["x"] as float, att_dict["y"] as float, 2 ])
				

func build_grid():
	var b_x = baseGrid.x as int
	var b_y = baseGrid.y as int
	create_grid_element(0,0,0,0,1)
	create_grid_element(b_x -1,0,4,0,1)
	create_grid_element(0,b_y -1,0,4,1)
	create_grid_element(b_x -1,b_y -1,4,4,1)
	for x in range(1,b_x-1):
		create_grid_element(x,0,1,0,1)
		create_grid_element(x,b_y -1,3,4,1)
	for y in range(1,b_y -1):
		create_grid_element(0,y,0,3,1)
		create_grid_element(b_x -1,y,4,1,1)
	for x in range(1,b_x -1):
		for y in range(1,b_y -1):
			create_grid_element(x,y,2,2,0)
	pass

func build_objects():
	for obj in blockList:
		match obj.z:
			2.0:
				create_grid_element(obj.x,obj.y,5,0,1)
			3.0:
				create_grid_element(obj.x,obj.y,5,1,1)
				$Map.erase_cell(0,Vector2(obj.x,obj.y))
				blockList2.push_back(Vector2(obj.x,obj.y))
			4.0:
				create_grid_element(obj.x,obj.y,5,2,1)
				$Map.erase_cell(0,Vector2(obj.x,obj.y))
			_:
				print("uh oh")

func create_grid_element(x,y,tx,ty,l):
	if Global.osaka_mode_on:
		$Map.set_cell(l,Vector2i(x,y),1,Vector2i(tx,ty),0)
	else:
		$Map.set_cell(l,Vector2i(x,y),2,Vector2i(tx,ty),0)
	pass

func build_enemies():
	print(enemyDetails)
	for e in enemyDetails:
		print(e)
		var enemy
		if e[3] == 1.0:
			enemy = load("res://Enemies/"+e[0]+"Enemy/"+e[0]+"_enemy.tscn" )
		elif e[3] == 2:
			enemy = load("res://Enemies/"+e[0]+"Enemy/"+e[0]+"_tank.tscn")
		if(enemy == null):
			print("no good tank")
			return
		var e2 = enemy.instantiate()
		e2.position = Vector2( e[1] *scaler + scaler/2, e[2] *scaler + scaler/2) 
		add_child(e2)
		if e[0] != "cyan" && e[0] != "mini":
			enemies += 1
			print(enemies)
		e2.add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timer += _delta
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().root.add_child(pause_menu.instantiate())
		get_tree().paused = true

func _on_finish_button_level_finish():
	Global.level_success = true
	finish()
	pass # Replace with function body.


func _on_tank_hull_level_finish():
	Global.level_success = false
	finish()
	pass # Replace with function body.
	
func finish():
	if Global.adventureMode && str(Global.get_level()).begins_with("h"):
		Global.goto_scene("res://Menus/main_menu.tscn")
	else:
		if (timer as int % 60) as int < 10:
			Global.time_taken = str( (timer / 60) as int) + ":0" + str((timer as int % 60) as int)
		else:
			Global.time_taken = str( (timer / 60) as int) + ":" + str((timer as int % 60) as int)
		Global.goto_scene("res://Menus/game_over_menu.tscn")
		

func play_bullet_play():
	$AudioStreamPlayer2D.play()
