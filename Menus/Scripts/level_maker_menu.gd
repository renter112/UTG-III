extends Control

var baseGrid : Vector2

var selected : Vector2i

var selected_opts = ["player",""]
func _input(event):
	if event is InputEventMouseButton:
		if event.position.y > 192 && event.position.y < 64 + baseGrid.y*64 && event.position.x > 64 && event.position.x < baseGrid.x *64 -64:
			var e = $TileMap.local_to_map(Vector2(event.position.x,event.position.y-128))
			check_select(e)

func check_select(e):
	print(e)
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

