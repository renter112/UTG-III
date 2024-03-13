extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_button_pressed():
	get_tree().paused = false
	if Global.adventureMode:
		Global.goto_scene("res://Menus/main_menu.tscn")
	else:
		Global.goto_scene("res://Menus/level_select.tscn")
		queue_free()
	pass # Replace with function body.


func _on_resume_button_pressed():
	get_tree().paused = false
	queue_free()
	pass # Replace with function body.
