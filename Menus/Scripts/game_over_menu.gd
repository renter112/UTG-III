extends Control


func _ready():
	if Global.success && !Global.adventureMode:
		$MarginContainer/VBoxContainer/Label.text = "SUCCESS"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = false
	elif !Global.success && !Global.adventureMode:
		$MarginContainer/VBoxContainer/Label.text = "FAILURE"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = true
		
	if Global.success && Global.adventureMode:
		$MarginContainer/VBoxContainer/Label.text = "SUCCESS"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = false
		$MarginContainer/VBoxContainer/ButtonsCon/RetryButton.disabled = true
	elif !Global.success && Global.adventureMode:
		$MarginContainer/VBoxContainer/Label.text = "FAILURE"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = true
		$MarginContainer/VBoxContainer/ButtonsCon/RetryButton.disabled = true
		
	$MarginContainer/VBoxContainer/InfoCon/AttemptsLabel.text = "Attempts: " + str(Global.attempts)
	$MarginContainer/VBoxContainer/InfoCon/TimeLabel.text = "Timer: " + str(Global.time)
	$MarginContainer/VBoxContainer/InfoCon/ShotsLabel.text = "Shots Fired: " + str(Global.shots)
	pass # Replace with function body.



func _on_retry_button_pressed():
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed():
	if Global.get_adventureMode():
		Global.goto_scene("res://Menus/main_menu.tscn")
	else:
		Global.goto_scene("res://Menus/level_select.tscn")
	pass # Replace with function body.


func _on_next_button_pressed():
	if Global.get_adventureMode():
		# ADVENTURE MODE IS TRUE
		if str(Global.get_level()).begins_with("e"):
			Global.set_level("m" + str(randi_range(1, 3)))
		elif str(Global.get_level()).begins_with("m"):
			Global.set_level("h" + str(randi_range(1, 3)))
		Global.goto_scene("res://LevelTools/level.tscn")
	else:
		# ADVENTURE MODE IS FALSE
		Global.level = int(Global.level) +1
		Global.goto_scene("res://LevelTools/level.tscn")
	
	pass # Replace with function body.
