extends Control

func _ready():
	if(Global.tank_controls_classic):
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlsButton.text = "CLASSIC"
	else:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlsButton.text = "MODERN"
	if Global.osaka_mode_on:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/OsakaButton.button_pressed = true
func _on_back_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.

func _on_osaka_button_toggled(toggled_on):
	if Global.osaka_mode_on :
		Global.osaka_mode_on = false
	else :
		Global.osaka_mode_on = true
	print(toggled_on)
	pass # Replace with function body.

func _on_control_button_pressed():
	if($MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlsButton.text == "CLASSIC"):
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlsButton.text = "MODERN"
		Global.tank_controls_classic = false
	else:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlsButton.text = "CLASSIC"
		Global.tank_controls_classic = true
	pass # Replace with function body.

func _on_music_button_toggled(toggled_on):
	if Global.music:
		Global.music = false
	else:
		Global.music = true
		
	pass # Replace with function body.


func _on_sounds_button_toggled(toggled_on):
	if Global.sounds:
		Global.sounds = false
	else:
		Global.sounds = true
		
	pass # Replace with function body.


func _on_full_screen_button_toggled(toggled_on):
	pass # Replace with function body.
