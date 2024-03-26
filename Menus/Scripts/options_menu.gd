extends Control

func _ready():
	Global.inGame = false
	
	if(Global.tank_controls_classic):
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer3/ControlsButton.text = "CLASSIC"
	else:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer3/ControlsButton.text = "MODERN"

	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/MusicButton.set_pressed_no_signal(!Global.music)
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/SoundsButton.set_pressed_no_signal(!Global.sounds)
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer4/OsakaButton.set_pressed_no_signal(!Global.osaka_mode_on)
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer4/FullScreenButton.set_pressed_no_signal(!Global.fullScreen)
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/MusicHSlider.value = db_to_linear(Global.music_v)
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/SFXHSlider.value = db_to_linear(Global.sounds_v)
	
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
	if($MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer3/ControlsButton.text == "CLASSIC"):
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer3/ControlsButton.text = "MODERN"
		Global.tank_controls_classic = false
	else:
		$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer3/ControlsButton.text = "CLASSIC"
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
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer2/BackButton.text = "Save"
	$MarginContainer/ColorRect/MarginContainer/VBoxContainer/MarginContainer2/BackButton.add_theme_color_override("font_color",Color(0,.7,0))
	need_saved = true


func _on_controls_view_button_pressed():
	Global.goto_scene("res://Menus/view_controls_menu.tscn")
	pass # Replace with function body.


func _on_reset_button_pressed():
	var save_file = FileAccess.open("user://save.save",FileAccess.WRITE)
	save_file.store_line("")
	pass # Replace with function body.


func _on_h_slider_value_changed(value):
	if value == 0:
		_on_music_button_toggled(Global.music)
	Global.music_v = linear_to_db(value)


func _on_music_h_slider_drag_ended(value_changed):
	update_back_button()

func _on_sfxh_slider_drag_ended(value_changed):
	update_back_button()


func _on_sfxh_slider_value_changed(value):
	if value == 0:
		_on_sounds_button_toggled(Global.sounds)
	Global.sounds_v = linear_to_db(value)
