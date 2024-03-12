extends Node2D

var baseGrid = Vector2(0,0)
var playerPos = Vector2(0,0)
var blockList = []
var enemies = 0
var scaler = 64 as int
var timer = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	parseXML()
	Global.enemies = enemies
	Global.shots = 0
	$cam.zoom = Vector2(min(1600/(baseGrid.x*scaler),896/(baseGrid.y*scaler)),min(1600/(baseGrid.x*scaler),896/(baseGrid.y*scaler)))
	build_grid()
	build_objects()
	pass # Replace with function body.

func parseXML():
	var parser = XMLParser.new()
	var level = Global.get_level()
	parser.open("res://LevelTools/levels/"+str(level)+".xml")
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
					"finish":
						$finish_button.position = Vector2i(att_dict["x"] as int *scaler + scaler/2, att_dict["y"] as int *scaler + scaler/2)
						type = -1
					_:
						type = -1
				if type != -1:
					blockList.append(Vector3(att_dict["x"] as int,att_dict["y"] as int,type))
			elif node_name == "tank":
				if att_dict["type"] == "p1":
					$tank_hull.position = Vector2(att_dict["x"] as int * scaler + scaler/2,att_dict["y"] as int *scaler + scaler/2)
			elif node_name == "enemy":
				var enemy = load("res://Enemies/"+att_dict["type"]+"Enemy/"+att_dict["type"]+"_enemy.tscn")
				if(enemy == null):
					break
				var e = enemy.instantiate()
				add_child(e)
				e.position = Vector2(att_dict["x"] as int *scaler + scaler/2, att_dict["y"] as int *scaler + scaler/2) 
				if att_dict["type"] != "cyan":
					enemies += 1
				e.add_to_group("enemies")

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
			4.0:
				create_grid_element(obj.x,obj.y,5,2,1)
			_:
				print("uh oh")

func create_grid_element(x,y,tx,ty,l):
	if Global.get_osaka():
		$Map.set_cell(l,Vector2i(x,y),1,Vector2i(tx,ty),0)
	else:
		$Map.set_cell(l,Vector2i(x,y),0,Vector2i(tx,ty),0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timer += _delta
	pass


func _on_finish_button_level_finish():
	Global.success = true
	Global.time = str( (timer / 60) as int) + ":" + str((timer as int % 60) as int)
	Global.goto_scene("res://Menus/game_over_menu.tscn")
	pass # Replace with function body.
