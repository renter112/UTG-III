extends Control

var button = preload("res://Menus/Assets/button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.attempts = 0
	for n in range(1,25):
		var b = button.instantiate()
		b.text = str(n)
		$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
	pass # Replace with function body.


func _on_return_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.


func _on_button_pressed():
	Global.set_osaka(true)
	pass # Replace with function body.
