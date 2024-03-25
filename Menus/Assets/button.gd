extends Button



func _ready():
	if not text.begins_with("T"):
		for l in Global.levels:
			if l[1] == text && l[3]==1:
				add_theme_color_override("font_color",Color(0,1,0))
	
	#for s in Global.levels_cleared:
		#if s == Global.level_dict.get(text+".xml")[1] :


func _on_pressed():
	if not text.begins_with("T"):
		for level in Global.levels :
			if text == level[1]:
				Global.current_level = level
	else :
		for level in Global.t_levels:
			if text == level[1]:
				Global.current_level = level
	#for lvl in Global.level_dict:
		#if Global.level_dict[lvl][0] == text:
			#print(lvl)
			#Global.level = str(lvl)

	Global.adventureMode = false
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
