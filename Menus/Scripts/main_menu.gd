extends Control



func _on_level_select_button_pressed():
	Global.goto_scene("res://Menus/level_select.tscn")
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_option_button_pressed():
	Global.goto_scene("res://Menus/options_menu.tscn")
	pass # Replace with function body.


func _on_adventure_button_pressed():
	# this just loads a random level rn
	Global.set_adventureMode(true)
	var random_number = randi_range(1, 7)
	Global.set_level(random_number)
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
