extends Button

func _ready():
	if Global.levels_cleared.has(text):
		add_theme_color_override("font_color",Color(0,1,0))
		print()

func _on_pressed():
	Global.set_level(text)
	Global.set_adventureMode(false)
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
