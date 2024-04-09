extends Control

func _ready():
	$MarginContainer/VBoxContainer/InfoCon/ScoreLabel.text = "Score: "+str(Global.score)

func _on_retry_button_pressed():
	AudioStreamPlayer2d.playing = true
	Global.goto_scene("res://Menus/adventure_mode_menu.tscn")
	pass # Replace with function body.
