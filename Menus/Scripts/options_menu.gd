extends Control

func _ready():
	if(Global.tank_controls_classic):
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlButton.text = "CLASSIC"
	else:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlButton.text = "MODERN"

func _on_back_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.




func _on_button_3_toggled(toggled_on):
	Global.set_osaka(true)
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
