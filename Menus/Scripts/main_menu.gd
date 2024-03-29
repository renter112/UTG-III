extends Control

@onready var error_notif = preload("res://Menus/Assets/import_notification.tscn")

func _ready():
	if Global.notif_error:
		var err = error_notif.instantiate()
		err.get_node("Label").text = "ERROR LOADING LEVEL"
		add_child(err)
		Global.notif_error = false

func _on_play_button_pressed():
	Global.goto_scene("res://Menus/level_selector_menu_menu.tscn")
	pass # Replace with function body.

func _on_option_button_pressed():
	Global.goto_scene("res://Menus/options_menu.tscn")
	pass # Replace with function body.

func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.





