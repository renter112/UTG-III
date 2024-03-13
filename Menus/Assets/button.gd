extends Button



func _on_pressed():
	Global.set_level(text)
	Global.set_adventureMode(false)
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
