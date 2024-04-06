extends Control

func _ready():
	scale = Vector2(1/Global.camera_zoom.x,1/Global.camera_zoom.y)

func _on_quit_button_pressed():
	get_tree().paused = false
	AudioStreamPlayer2d.playing = true
	Global.reset_upgrade_list()
	if Global.adventureMode:
		Global.goto_scene("res://Menus/main_menu.tscn")
		queue_free()
	elif Global.custom_level_on:
		Global.goto_scene("res://Menus/custom_levels_menu.tscn")
		queue_free()
	else:
		Global.goto_scene("res://Menus/level_select.tscn")
		queue_free()
	pass # Replace with function body.

func _on_resume_button_pressed():
	print("unpause button")
	queue_free()
	get_tree().paused = false
	pass # Replace with function body.

func _on_retry_button_pressed():
	get_tree().paused = false
	Global.goto_scene("res://LevelTools/level.tscn")
	queue_free()
	pass # Replace with function body.

func _on_controls_button_pressed():
	get_tree().paused = false
	Global.inGame = true
	Global.attempts_taken -= 1
	Global.goto_scene("res://Menus/view_controls_menu.tscn")
	pass # Replace with function body.

