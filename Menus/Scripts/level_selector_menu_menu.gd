extends Control

func _ready():
	Global.custom_level_on = false

func _on_level_select_button_pressed():
	Global.goto_scene("res://Menus/level_select.tscn")
	pass # Replace with function body.


func _on_adventure_button_pressed():
	print("do later tbh")
	pass # Replace with function body.


func _on_custom_button_pressed():
	Global.goto_scene("res://Menus/custom_levels_menu.tscn")
	pass # Replace with function body.


func _on_map_builder_button_pressed():
	Global.goto_scene("res://Menus/level_maker_menu.tscn")
	pass # Replace with function body.


func _on_back_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.
