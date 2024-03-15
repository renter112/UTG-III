extends Control


func _ready():
	if Global.level_success && !Global.adventureMode:
		$MarginContainer/VBoxContainer/Label.text = "SUCCESS"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = false
		$AudioStreamPlayer2D.playing = true
	elif !Global.level_success && !Global.adventureMode:
		$MarginContainer/VBoxContainer/Label.text = "FAILURE"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = true
		
	if Global.level_success && Global.adventureMode:
		$MarginContainer/VBoxContainer/Label.text = "SUCCESS"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = false
		$MarginContainer/VBoxContainer/ButtonsCon/RetryButton.disabled = true
	elif !Global.level_success && Global.adventureMode:
		$MarginContainer/VBoxContainer/Label.text = "FAILURE"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = true
		$MarginContainer/VBoxContainer/ButtonsCon/RetryButton.disabled = true
		
	$MarginContainer/VBoxContainer/InfoCon/AttemptsLabel.text = "Attempts: " + str(Global.attempts_taken)
	$MarginContainer/VBoxContainer/InfoCon/TimeLabel.text = "Timer: " + str(Global.time_taken)
	$MarginContainer/VBoxContainer/InfoCon/ShotsLabel.text = "Shots Fired: " + str(Global.shots_taken)
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
		Global.attempts_taken = 0
		Global.level = int(Global.level) +1
		Global.goto_scene("res://LevelTools/level.tscn")
	
	pass # Replace with function body.
