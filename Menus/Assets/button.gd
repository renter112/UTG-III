extends Button

func _ready():
	for s in Global.levels_cleared:
		if s == Global.level_dict.get(text+".xml")[1] :
			add_theme_color_override("font_color",Color(0,1,0))


func _on_pressed():
	for lvl in Global.level_dict:
		if Global.level_dict[lvl][0] == text:
			print(lvl)
			Global.level = str(lvl)

	Global.adventureMode = false
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
