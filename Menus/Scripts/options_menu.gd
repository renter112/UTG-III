extends Control



func _on_back_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.




func _on_button_3_toggled(toggled_on):
	Global.set_osaka(true)
	print(toggled_on)
	pass # Replace with function body.
