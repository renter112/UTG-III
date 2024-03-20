extends Button

func _ready():
	for s in Global.levels_cleared:
		if s == Global.level_dict.get(text+".xml")[1] :
			add_theme_color_override("font_color",Color(0,1,0))


func _on_pressed():
<<<<<<< HEAD
	for lvl in Global.level_dict:
		if Global.level_dict[lvl][0] == text:
			print("FUKC",Global.level_dict[lvl][0])
			Global.level = lvl
	Global.set_adventureMode(false)
=======
	Global.set_level(text)
	Global.adventureMode = false
>>>>>>> 995d53c3fa6bd94d59b65b75667ccdf250cd08ca
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
