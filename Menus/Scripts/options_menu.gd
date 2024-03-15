extends Control

func _ready():
	if(Global.tank_controls_classic):
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlButton.text = "CLASSIC"
	else:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlButton.text = "MODERN"
	if Global.osaka_mode_on:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/Button3.button_pressed = true
func _on_back_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.




func _on_button_3_toggled(toggled_on):
	if Global.osaka_mode_on :
		Global.osaka_mode_on = false
	else :
		Global.osaka_mode_on = true
	print(toggled_on)
	pass # Replace with function body.



func _on_control_button_pressed():
	if($MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlButton.text == "CLASSIC"):
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlButton.text = "MODERN"
		Global.tank_controls_classic = false
	else:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlButton.text = "CLASSIC"
		Global.tank_controls_classic = true
	pass # Replace with function body.
