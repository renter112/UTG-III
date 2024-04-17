extends Control

func _ready():
	var t = Global.upgrade_list
	$MarginContainer/modMenu/gunMenu/gunSlider.value = t["gun"]
	$MarginContainer/modMenu/speedMenu/speedSlider.value = t["speed"]
	if (t["side_armor"] != 0.0):
		$MarginContainer/modMenu/togglesMenu/HBoxContainer/sideCheck.button_pressed = true
	if (t["invincible"] != 0.0):
		$MarginContainer/modMenu/togglesMenu/HBoxContainer2/inviCheck.button_pressed = true


func _on_side_check_toggled(toggled_on):
	if toggled_on:
		Global.upgrade_list["side_armor"] = 1.0
	else:
		Global.upgrade_list["side_armor"] = 0.0
	pass # Replace with function body.


func _on_invi_check_toggled(toggled_on):
	if toggled_on:
		Global.upgrade_list["invincible"] = 1.0
	else:
		Global.upgrade_list["invincible"] = 0.0
	pass # Replace with function body.


func _on_speed_slider_drag_ended(value_changed):
	Global.upgrade_list["speed"] = $MarginContainer/modMenu/speedMenu/speedSlider.value
	pass # Replace with function body.


func _on_gun_slider_drag_ended(value_changed):
	Global.upgrade_list["gun"] = $MarginContainer/modMenu/gunMenu/gunSlider.value
	pass # Replace with function body.


func _on_button_pressed():
	if position.y == 896:
		position.y = 700
		return
	elif position.y == 700:
		position.y = 896
	pass # Replace with function body.
