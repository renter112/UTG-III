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
	AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))
	pass # Replace with function body.


func _on_sounds_button_toggled(toggled_on):
	if Global.sounds:
		Global.sounds = false
	else:
		Global.sounds = true
	AudioServer.set_bus_mute(2, not AudioServer.is_bus_mute(2))
	pass # Replace with function body.


func _on_full_screen_button_toggled(toggled_on):
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Global.fullScreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Global.fullScreen = false
	pass # Replace with function body.


func _on_credits_button_pressed():
	Global.goto_scene("res://Menus/credits.tscn")
	pass # Replace with function body.
