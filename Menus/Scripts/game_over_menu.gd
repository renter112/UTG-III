extends Control


func _ready():
	# If level successful 
	if Global.level_success:
		for lvl in Global.level_dict:
			if lvl == Global.level:
				Global.levels_cleared.push_back(Global.level_dict[lvl][1])
				Global.save_levels_beaten()
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
		Global.level = str(int(Global.level.get_basename()) +1 )+".xml"
		Global.goto_scene("res://LevelTools/level.tscn")
	
	pass # Replace with function body.
