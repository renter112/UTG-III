extends Control

func _ready():
	Global.load_save_config()
	Global.load_levels()
	Global.load_levels_beaten()


	
func _on_play_button_pressed():
	Global.goto_scene("res://Menus/level_selector_menu_menu.tscn")
	pass # Replace with function body.

func _on_option_button_pressed():
	Global.goto_scene("res://Menus/options_menu.tscn")
	pass # Replace with function body.

func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.





