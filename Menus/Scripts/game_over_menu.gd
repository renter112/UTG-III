extends Control


func _ready():
	if Global.success:
		$MarginContainer/VBoxContainer/Label.text = "SUCCESS"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = false
	else:
		$MarginContainer/VBoxContainer/Label.text = "FAILURE"
		$MarginContainer/VBoxContainer/ButtonsCon/NextButton.disabled = true
		
	$MarginContainer/VBoxContainer/InfoCon/AttemptsLabel.text = "Attempts: " + str(Global.attempts)
	$MarginContainer/VBoxContainer/InfoCon/TimeLabel.text = "Timer: " + str(Global.time)
	$MarginContainer/VBoxContainer/InfoCon/ShotsLabel.text = "Shots Fired: " + str(Global.shots)
	pass # Replace with function body.



func _on_retry_button_pressed():
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed():
	Global.goto_scene("res://Menus/level_select.tscn")
	pass # Replace with function body.


func _on_next_button_pressed():
	Global.level = int(Global.level) +1
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
