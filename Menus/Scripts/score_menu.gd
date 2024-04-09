extends Control

func _ready():
	Global.load_scores()
	for score in Global.scores:
		var lbl = Label.new()
		lbl.text = str(score[0]) + "  " + str(score[1])
		$MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer.add_child(lbl)


func _on_back_button_pressed():
	Global.goto_scene("res://Menus/adventure_mode_menu.tscn")
	pass # Replace with function body.
