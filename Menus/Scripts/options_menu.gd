extends Control

@onready var skin_label = get_node("MarginContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer4/SkinLabel")

func _ready():
	Global.inGame = false
	$MarginContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer5/FullScreenButton.set_pressed_no_signal(!Global.fullScreen)
	$MarginContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/MusicHSlider.value = db_to_linear(Global.music_v)
	$MarginContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/SFXHSlider.value = db_to_linear(Global.sounds_v)
	update_skin_label()
	
func _on_back_button_pressed():
	if need_saved:
		Global.save_config()
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.

func _on_osaka_button():
	Global.tile_set_sel += 1
	if Global.tile_set_sel == 4:
		Global.tile_set_sel = 0
	update_skin_label()
	update_back_button()
	pass # Replace with function body.

func update_skin_label():
	match Global.tile_set_sel:
		0:
			skin_label.text = "Sand Box"
		1:
			skin_label.text = "Special"
		2:
			skin_label.text = "Default"
		3:
			skin_label.text = "Icy"



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
	$MarginContainer/MarginContainer/VBoxContainer/MarginContainer2/BackButton.text = "Save"
	$MarginContainer/MarginContainer/VBoxContainer/MarginContainer2/BackButton.add_theme_color_override("font_color",Color(0,.7,0))
	need_saved = true


func _on_controls_view_button_pressed():
	Global.goto_scene("res://Menus/view_controls_menu.tscn")
	pass # Replace with function body.


func _on_reset_button_pressed():
	var save_file = FileAccess.open("user://save.save",FileAccess.WRITE)
	save_file.store_line("")
	Global.load_save_config()
	pass # Replace with function body.


func _on_h_slider_value_changed(value):
	Global.music_v = linear_to_db(value)

func _on_music_h_slider_drag_ended(value_changed):
	Global.update_settings()
	update_back_button()

func _on_sfxh_slider_drag_ended(value_changed):
	Global.update_settings()
	update_back_button()


func _on_sfxh_slider_value_changed(value):
	Global.sounds_v = linear_to_db(value)
