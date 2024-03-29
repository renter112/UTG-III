extends Button

var level_to_load : Array

func _ready():
	if not level_to_load.is_empty():
		if level_to_load[3]:
			add_theme_color_override("font_color",Color(0,1,0))
	
	#for s in Global.levels_cleared:
		#if s == Global.level_dict.get(text+".xml")[1] :


func _on_pressed():
	Global.current_level = level_to_load
	Global.adventureMode = false
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
