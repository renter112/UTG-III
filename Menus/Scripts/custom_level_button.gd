extends Button

var level_to_load = []
# Called when the node enters the scene tree for the first time.
func _ready():
	print(level_to_load[3])
	if level_to_load[3] == 1:
		add_theme_color_override("font_color",Color(0,1,0))
	pass # Replace with function body.




func _on_pressed():
	Global.current_level = level_to_load
	Global.custom_level_on = true
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
