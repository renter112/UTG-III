extends Control

var button = preload("res://Menus/Assets/button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.custom_level_on = false
	Global.attempts_taken = 0
	Global.shots_taken = 0
	Global.time_taken = 0

	if Global.played_game_before:
		for n in range(1,25):
			var b = button.instantiate()
			b.text = str(n)
			$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
	else:
		for n in range(1,9):
			var b = button.instantiate()
			b.text = str("T",n)
			$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
	Global.played_game_before = true
	Global.save_config()
	pass # Replace with function body.


func _on_return_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.



func _on_back_button_pressed():
	var buttons = $MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.get_children()
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
	var buttons = $MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.get_children()
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
		else:
			b.text = str(n)
		$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
		


func _on_button_pressed():
	Global.goto_scene("res://Menus/custom_levels_menu.tscn")
	pass # Replace with function body.
