extends Control

var baseGrid : Vector2

var selected = Vector2i(2,2)
var cur_level = []

var selected_opts = {"wall":Vector2i(5,1),"hole":Vector2i(5,0),
"red_tank":Vector2i(6,0),"orange_tank":Vector2i(6,1),"yellow_tank":Vector2i(6,2),"blue_tank":Vector2i(6,3),
"cyan_tank":Vector2i(6,4),"mini_tank":Vector2i(5,4),"red_turret":Vector2i(0,5),"orange_turret":Vector2i(1,5),
"yellow_turret":Vector2i(2,5),"blue_turret":Vector2i(3,5),"cyan_turret":Vector2i(4,5),"purple_turret":Vector2i(5,5),
"boss_turret":Vector2i(6,5),"player":Vector2i(5,2),"finish":Vector2i(5,3),"none":Vector2i(2,2)}

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		var event = get_viewport().get_mouse_position()
		if event.y > 192 && event.y < 64 + baseGrid.y*64 && event.x > 64 && event.x < baseGrid.x *64 -64:
			var e = $TileMap.local_to_map(Vector2(event.x,event.y-128))
			check_select(e)

func check_select(e):
	if $TileMap.get_cell_atlas_coords(1,e) == selected:
		$TileMap.set_cell(1,e,1,Vector2i(2,2),0)
	else:
		$TileMap.set_cell(1,e,1,selected,0)


func _on_generate_button_pressed():
	$TileMap.clear()
	baseGrid.x = int( $"TabContainer/Grid Builder/XLineEdit".text)
	baseGrid.y = int( $"TabContainer/Grid Builder/YLineEdit".text)
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
	pass # Replace with function body.


func create_grid_element(x,y,tx,ty,l):
	$TileMap.set_cell(l,Vector2i(x,y),1,Vector2i(tx,ty),0)
	pass
	
func _on_player_button_pressed():
	selected = Vector2i(5,2)
func _on_finish_button_pressed():
	selected = Vector2i(5,3)
func _on_wall_button_pressed():
	selected = Vector2i(5,1)
func _on_hole_button_pressed():
	selected = Vector2i(5,0)
func _on_red_tur_button_pressed():
	selected = Vector2i(0,5)
func _on_org_tur_button_pressed():
	selected = Vector2i(1,5)
func _on_yel_tur_button_pressed():
	selected = Vector2i(2,5)
func _on_blu_tur_button_pressed():
	selected = Vector2i(3,5)
func _on_cya_tur_button_pressed():
	selected = Vector2i(4,5)
func _on_pur_tur_button_pressed():
	selected = Vector2i(5,5)
func _on_bos_tur_button_pressed():
	selected = Vector2i(6,5)
func _on_red_tank_button_pressed():
	selected = Vector2i(6,0)
func _on_org_tank_button_pressed():
	selected = Vector2i(6,1)
func _on_yel_tank_button_pressed():
	selected = Vector2i(6,2)
func _on_blu_tank_button_pressed():
	selected = Vector2i(6,3)
func _on_cya_tank_button_pressed():
	selected = Vector2i(6,4)
func _on_min_tank_button_pressed():
	selected = Vector2i(5,4)


var xml_elements : Array
func _on_save_button_pressed():
	var player_check = 0
	var finish_check = 0
	xml_elements.clear()
	for x in range(1,baseGrid.x -1):
		for y in range(1,baseGrid.y -1):
			var atlas = $TileMap.get_cell_atlas_coords(1,Vector2i(x,y))
			if atlas.x != -1:
				var type = selected_opts.find_key(atlas)
				print(type)
				if type == "player":
					player_check += 1
					xml_elements.push_back("<player x=\""+str(x)+"\" y=\""+str(y)+"\" type=\"p1\" ></player>")
				elif type == "finish" :
					finish_check += 1
					xml_elements.push_back("<coord x=\""+str(x)+"\" y=\""+str(y)+"\" type=\"finish\" ></coord>")
				elif type == "wall":
					xml_elements.push_back("<coord x=\""+str(x)+"\" y=\""+str(y)+"\" type=\"block\" ></coord>")
				elif type == "hole":
					xml_elements.push_back("<coord x=\""+str(x)+"\" y=\""+str(y)+"\" type=\"hole\" ></coord>")
				elif type.ends_with("tank") or type.ends_with("turret"):
					type = type.split("_")
					xml_elements.push_back("<"+str(type[1])+" x=\""+str(x)+"\" y=\""+str(y)+"\" type=\""+type[0]+"\"></"+type[1]+">")
					
	if player_check == 0 or player_check > 1:
		notif("You need 1 player")
	elif finish_check == 0 or finish_check > 1:
		notif("You need 1 finish")
	else:
		save_xml()
	print(xml_elements)
	pass # Replace with function body.

func notif(ntn):
	$Label.visible = true
	$Label.text = str(ntn)
	$Label/Timer.start(2)
	

func save_xml():
	var check = DirAccess.open("user://")
	var seed = ""+str(randi())+""+str(randi())
	var name = "Unnamed_level"
	if $TabContainer/Required/NameLineEdit.text != "":
		name = $TabContainer/Required/NameLineEdit.text
	var filename = name
	if not check.dir_exists("levels"):
		check.make_dir("user://levels")
	var user = "UTG2-Editor"
	if FileAccess.file_exists("user://levels/"+name+".utg2"):
		filename = name + str(seed)
	var file = FileAccess.open(str("user://levels/"+filename+".utg2"), FileAccess.WRITE)
	file.store_line("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>")
	file.store_line("<level>")
	file.store_line(str("<levelName name=\""+name+"\"></levelName> "))
	file.store_line(str("<levelSeed seed=\""+ seed+"\"></levelSeed> "))
	file.store_line(str("<author user=\""+ user+"\"></author> "))
	file.store_line("<grid x=\""+ str(+baseGrid.x) +"\" y=\""+ str(baseGrid.y) +"\"></seed> ")
	file.store_line("<objects>")
	for el in xml_elements:
		if el.begins_with("<coord"):
			file.store_line(el)
	file.store_line("</objects>")
	file.store_line("<enemies>")
	for el in xml_elements:
		if el.begins_with("<player") or el.begins_with("<tank") or el.begins_with("<turret"):
			file.store_line(el)
	file.store_line("</enemies>")
	cur_level = [str(filename)+".utg2",name,seed,0]
	$Label.visible = true
	$Label.text = "LEVEL SAVED"
	$Label/Timer.start(2)

func _on_return_button_pressed():
	Global.goto_scene("res://Menus/level_selector_menu_menu.tscn")
	pass # Replace with function body.


func _on_timer_timeout():
	$Label.visible = false
	pass # Replace with function body.


func _on_play_button_pressed():
	_on_save_button_pressed()
	Global.custom_level_on = true
	Global.load_custom_levels()
	Global.current_level = cur_level
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
