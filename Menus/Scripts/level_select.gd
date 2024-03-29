extends Control

var button = preload("res://Menus/Assets/button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.custom_level_on = false
	Global.attempts_taken = 0
	Global.shots_taken = 0
	Global.time_taken = 0

	if Global.played_game_before:
		create_buttons(1,25)
	else:
		create_buttons(1,9)
	Global.played_game_before = true
	Global.save_config()
	pass # Replace with function body.


func _on_return_button_pressed():
	Global.goto_scene("res://Menus/level_selector_menu_menu.tscn")
	pass # Replace with function body.



func _on_back_button_pressed():
	var buttons = $MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.get_children()
	var lastButtonNum = buttons.back().text
	var minLevel = 1
	for b in buttons:
		b.queue_free()
	if lastButtonNum == "48":
		create_buttons(1,25)
	else:
		create_buttons(1,9)
	pass # Replace with function body.


func _on_forward_button_pressed():
	var buttons = $MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.get_children()
	var lastButtonNum = buttons.back().text
	for b in buttons :
		b.queue_free()
	
	if lastButtonNum == "T8":
		create_buttons(1,25)
	else:
		create_buttons(25,49)
	pass # Replace with function body.

func create_buttons(start,end):
	for n in range(start,end):
		var b = button.instantiate()
		if end == 9:
			b.text = str("T",n)
			b.level_to_load = Global.t_levels[n -1]
		else:
			b.text = str(n)
			if Global.levels.size() <= n:
				b.level_to_load = []
			else:
				print(Global.levels[n-1])
				b.level_to_load = Global.levels[n -1]
		$MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
		


func _on_button_pressed():
	Global.goto_scene("res://Menus/custom_levels_menu.tscn")
	pass # Replace with function body.
