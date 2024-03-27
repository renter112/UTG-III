extends Control

var level_b

func _ready():
	# If level successful 
	if Global.level_success:
		if Global.custom_level_on:
			$MarginContainer/VBoxContainer/MarginContainer/ButtonsCon/NextButton.disabled = true
			for level in Global.custom_levels:
				if level[2] == Global.current_level[2]:
					level[3] = 1
					Global.save_custom_levels()
		if Global.t_levels.has(Global.current_level):
			print("tut is on")
			if Global.t_levels.back() == Global.current_level:
				level_b = Global.levels[0]
			else:
				level_b = Global.t_levels[Global.t_levels.find(Global.current_level) +1]
			print("next level is: ",level_b)
		elif Global.levels.has(Global.current_level):
			if Global.levels.back() == Global.current_level:
				Global.goto_scene("res://Menus/credits.tscn")
			level_b = Global.levels[Global.levels.find(Global.current_level) +1]
			Global.save_levels()

		$MarginContainer/VBoxContainer/Label.text = "SUCCESS"
		$MarginContainer/TextureRect.texture = preload("res://Menus/Assets/result_success.png")
		$MarginContainer/VBoxContainer/MarginContainer/ButtonsCon/NextButton.disabled = false
		# level success, not adventure
		if not Global.adventureMode :
			$AudioStreamPlayer2D.playing = true
	# level fail
	else :
		$AudioStreamPlayer2D.playing = false
		$MarginContainer/VBoxContainer/Label.text = "FAILURE"
		$MarginContainer/TextureRect.texture = preload("res://Menus/Assets/result_fail.png")
		$MarginContainer/VBoxContainer/MarginContainer/ButtonsCon/NextButton.disabled = true
		
	# in adventure mode
	if Global.adventureMode :
		Global.attempts_taken = 0 #reset attempts if its adventure, no level select otherwise
		$MarginContainer/VBoxContainer/MarginContainer/ButtonsCon/RetryButton.disabled = true

		
	$MarginContainer/VBoxContainer/InfoCon/AttemptsLabel.text = "Attempts: " + str(Global.attempts_taken)
	$MarginContainer/VBoxContainer/InfoCon/TimeLabel.text = "Timer: " + str(Global.time_taken)
	$MarginContainer/VBoxContainer/InfoCon/ShotsLabel.text = "Shots Fired: " + str(Global.shots_taken)
	if Global.osaka_mode_on :
		$MarginContainer/TextureRect.texture = preload("res://Menus/Assets/osaka-100-yard-stare-by-me-v0-b064yxmkl0zb1.png")
	pass # Replace with function body.



func _on_retry_button_pressed():
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed():
	if Global.adventureMode:
		Global.goto_scene("res://Menus/main_menu.tscn")
	elif Global.custom_level_on:
		Global.goto_scene("res://Menus/custom_levels_menu.tscn")
	else:
		Global.goto_scene("res://Menus/level_select.tscn")
	pass # Replace with function body.


func _on_next_button_pressed():
	if Global.adventureMode:
		# ADVENTURE MODE IS TRUE
		if str(Global.get_level()).begins_with("e"):
			Global.set_level("m" + str(randi_range(1, 3)))
		elif str(Global.get_level()).begins_with("m"):
			Global.set_level("h" + str(randi_range(1, 3)))
		Global.goto_scene("res://LevelTools/level.tscn")
	else:
		# ADVENTURE MODE IS FALSE
		Global.attempts_taken = 0
		#Global.level = int(Global.level.get_basename()) +1 )+".xml"
		Global.current_level = level_b
		Global.goto_scene("res://LevelTools/level.tscn")
	
	pass # Replace with function body.
