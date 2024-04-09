extends Node2D

var baseGrid = Vector2(0,0)
var playerPos = Vector2(0,0)
var blockList = []
var enemyDetails = []
var enemies = 0
var scaler = 64 as int
var timer = 0 
var tile_sel = Global.tile_set_sel

var tank_types = ["red","blue","yellow","mini","cyan","orange"]
var turret_types = ["red","blue","yellow","boss","cyan","orange","purple"]

var pause_menu = preload("res://Menus/pause_menu.tscn")
var g_i = preload("res://Items/gun_upgrade.tscn")
var s_i = preload("res://Items/speed_upgrade.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioStreamPlayer2d.playing = false
	if parseXML():
		Global.attempts_taken += 1
		Global.shots_taken = 0
		$cam.zoom = Vector2(min(1600/(baseGrid.x*scaler),896/(baseGrid.y*scaler)),min(1600/(baseGrid.x*scaler),896/(baseGrid.y*scaler)))
		Global.camera_zoom = $cam.zoom
		$Label2.position = Vector2(baseGrid.x*scaler - 275,0)
		$Label3.position = Vector2(0,baseGrid.y*scaler - 64)
		build_grid()
		build_objects()
		build_enemies()
		set_upgrades()
		Global.enemies = enemies
	else:
		Global.level_err = true
		Global.goto_scene("res://Menus/main_menu.tscn")
		pass # Replace with function body.

func parseXML():
	var parser = XMLParser.new()
	var level = Global.current_level
	print(level)
	if level.is_empty():
		return false
	print("level loading is: ",level)
	if Global.adventureMode :
		parser.open(str("res://LevelTools/AdventureLevels/",level[0]))
		$Label.text = "Level "+str(Global.adventure_mode_level_num)+"/"+str(Global.adventure_mode_diff_selected[5])
		$Label.visible = true
		$Label2.text = "Lives "+str(Global.lives)
		$Label2.visible = true
		$Label3.visible = true
		$Label3.text = "Score "+str(Global.score)
	elif Global.custom_level_on :
		parser.open(str("user://levels/"+level[0]))
	elif level[1].begins_with("T"):
		parser.open(str("res://LevelTools/Tutorial/",level[0]))
	else:
		parser.open(str("res://LevelTools/levels/",level[0]))
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var att_dict = {}
			for idx in range(parser.get_attribute_count()):
				att_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if node_name == "grid":
				if att_dict.has("x") && att_dict.has("y"):
					baseGrid = Vector2(att_dict["x"] as int,att_dict["y"] as int)
				else:
					return false
			elif node_name == "coord":
				if att_dict.has("type") && att_dict.has("x") && att_dict.has("y"):
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
				if att_dict.has("type") && att_dict.has("x") && att_dict.has("y"):
					if att_dict["type"] == "p1":
						$tank_hull.position = Vector2(att_dict["x"] as int * scaler + scaler/2,att_dict["y"] as int *scaler + scaler/2)
				else:
					return false
				if att_dict.has("dir"):
					if att_dict["dir"] == "u":
						$tank_hull.rotation = deg_to_rad(270)
					elif att_dict["dir"] == "d":
						$tank_hull.rotation = deg_to_rad(90)
					elif att_dict["dir"] == "l":
						$tank_hull.rotation = deg_to_rad(180)
			elif node_name == "turret":
				if att_dict.has("type") && att_dict.has("y") && att_dict.has("x"):
					enemyDetails.push_back( [att_dict["type"],att_dict["x"] as float, att_dict["y"] as float, 1] )
			elif node_name == "tank":
				if att_dict.has("type") && att_dict.has("y") && att_dict.has("x"):
					enemyDetails.push_back( [ att_dict["type"], att_dict["x"] as float, att_dict["y"] as float, 2 ])
	return true

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

func update_score():
	$Label3.text = "Score: "+str(Global.score)

func build_objects():
	for obj in blockList:
		match obj.z:
			2.0:
				create_grid_element(obj.x,obj.y,5,0,1)
				create_grid_element_a(obj.x,obj.y,2,2,0,1)
			3.0:
				create_grid_element(obj.x,obj.y,5,1,1)
				$Map.erase_cell(0,Vector2(obj.x,obj.y))
			4.0:
				create_grid_element(obj.x,obj.y,5,2,1)
				$Map.erase_cell(0,Vector2(obj.x,obj.y))
			_:
				print("uh oh")

func create_grid_element(x,y,tx,ty,l):
	$Map.set_cell(l,Vector2i(x,y),tile_sel,Vector2i(tx,ty),0)
	pass
	
func create_grid_element_a(x,y,tx,ty,l,a):
	$Map.set_cell(l,Vector2i(x,y),tile_sel,Vector2i(tx,ty),a)
	pass

func build_enemies():
	for e in enemyDetails:
		var enemy
		if e[3] == 1.0:
			if e[0] == "random":
				e[0] = turret_types.pick_random()
			enemy = load("res://Enemies/"+e[0]+"Enemy/"+e[0]+"_enemy.tscn" )
		elif e[3] == 2:
			if e[0] == "random":
				e[0] = tank_types.pick_random()
			enemy = load("res://Enemies/"+e[0]+"Enemy/"+e[0]+"_tank.tscn")
		if(enemy == null):
			print("no good tank")
			return
		var e2 = enemy.instantiate()
		e2.position = Vector2( e[1] *scaler + scaler/2, e[2] *scaler + scaler/2) 
		add_child(e2)
		if e[0] != "cyan" && e[0] != "mini":
			enemies += 1
		e2.add_to_group("enemies")

var upgrade_loc = Vector2(3,64)
func set_upgrades():
	var s = Global.upgrade_list.get("speed")
	var g = Global.upgrade_list.get("gun")
	if g > 0 :
		$tank_hull/tank_turret.bullet_delay -= g/15
		$tank_hull/tank_turret.bullet_speed += g*20
		var g_l = g_i.instantiate()
		g_l.position = upgrade_loc
		add_child(g_l)
		upgrade_loc += Vector2(0,64)
	if s > 0:
		$tank_hull.speed += 22*s
		$tank_hull.rotation_speed += s/3
		var s_l = s_i.instantiate()
		s_l.position = upgrade_loc
		add_child(s_l)
		


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
	if Global.adventureMode:
		if not Global.level_success :
			print(Global.lives)
			if Global.lives > 1:
				Global.lives -= 1
				Global.goto_scene("res://LevelTools/level.tscn")
				return
			Global.goto_scene("res://Menus/adventure_mode_menu.tscn")
		else:
			print("LOAD NEXT LEVEL")
			var rng = RandomNumberGenerator.new()
			var a = rng.randi_range(0, 100)
			if Global.adventure_mode_diff_selected[0] > a and a > 0 :
				Global.current_level = Global.b_levels_play.pick_random()
				Global.b_levels_play.erase(Global.current_level)
			elif Global.adventure_mode_diff_selected[0]+Global.adventure_mode_diff_selected[1] > a :
				Global.current_level = Global.e_levels_play.pick_random()
				Global.e_levels_play.erase(Global.current_level)
			elif Global.adventure_mode_diff_selected[0]+Global.adventure_mode_diff_selected[1]+Global.adventure_mode_diff_selected[2] > a :
				Global.current_level = Global.m_levels_play.pick_random()	
				Global.m_levels_play.erase(Global.current_level)
				print("med")
			else :
				Global.current_level = Global.h_levels_play.pick_random()
				Global.h_levels_play.erase(Global.current_level)
				print("hard")
			Global.adventure_mode_level_num += 1
			print(Global.adventure_mode_level_num)
			if Global.adventure_mode_level_num >= Global.adventure_mode_diff_selected[5]:
				Global.goto_scene("res://Menus/credits.tscn")
				return
			if Global.adventure_mode_level_num % Global.adventure_mode_diff_selected[4] == 0:
				Global.goto_scene("res://LevelTools/upgrade_menu.tscn")
				return
			Global.score += (1000 * Global.adventure_mode_diff_selected[6])
			Global.goto_scene("res://LevelTools/level.tscn")
	else:
		if (timer as int % 60) as int < 10:
			Global.time_taken = str( (timer / 60) as int) + ":0" + str((timer as int % 60) as int)
		else:
			Global.time_taken = str( (timer / 60) as int) + ":" + str((timer as int % 60) as int)
		Global.goto_scene("res://Menus/game_over_menu.tscn")
		

