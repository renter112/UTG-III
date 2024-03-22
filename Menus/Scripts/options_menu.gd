extends Control

func _ready():
	if(Global.tank_controls_classic):
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlsButton.text = "CLASSIC"
	else:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/ControlsButton.text = "MODERN"

	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/MusicButton.set_pressed_no_signal(!Global.music)
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/SoundsButton.set_pressed_no_signal(!Global.sounds)
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/OsakaButton.set_pressed_no_signal(!Global.osaka_mode_on)
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/GridContainer/FullScreenButton.set_pressed_no_signal(!Global.fullScreen)
	
func _on_back_button_pressed():
	if need_saved:
		Global.save_config()
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.

func _on_osaka_button_toggled(toggled_on):
	if not toggled_on :
		Global.osaka_mode_on = true
	else :
		Global.osaka_mode_on = false
	update_back_button()
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
	if not toggled_on:
		print("turning music on!")
		Global.music = true
	else :
		print("turn off music")
		Global.music = false
	Global.update_settings()
	update_back_button()
	pass # Replace with function body.


func _on_sounds_button_toggled(toggled_on):
	if not toggled_on:
		Global.sounds = true
	else :
		Global.sounds = false
	Global.update_settings()
	update_back_button()
	pass # Replace with function body.


func _on_full_screen_button_toggled(toggled_on):
	if not toggled_on:
		Global.fullScreen = true
	else:
		Global.fullScreen = false
	Global.update_settings()
	update_back_button()
	pass # Replace with function body.


func _on_credits_button_pressed():
	Global.goto_scene("res://Menus/credits.tscn")
	pass # Replace with function body.

var need_saved = false
func update_back_button():
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/BackButton.text = "Save"
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/BackButton.add_theme_color_override("font_color",Color(0,.7,0))
	need_saved = true


func _on_controls_view_button_pressed():
	Global.goto_scene("res://Menus/view_controls_menu.tscn")
	pass # Replace with function body.
