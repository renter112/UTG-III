extends Control

var button = preload("res://Menus/Assets/button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.attempts = 0
	for n in range(1,25):
		var b = button.instantiate()
		b.text = str(n)
		b.name = str(n)
		$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
	pass # Replace with function body.


func _on_return_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.


func _on_button_pressed():
	Global.set_osaka(true)
	pass # Replace with function body.


func _on_back_button_pressed():
	var buttons = $MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.get_children()
	var lastButtonNum
	
	for b in buttons:
		lastButtonNum = int(b.text)
		b.queue_free()
	
	for n in range(lastButtonNum+1,lastButtonNum+25):
		var b = button.instantiate()
		b.text = str(n-48)
		$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
	pass # Replace with function body.


func _on_forward_button_pressed():
	var buttons = $MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.get_children()
	var lastButtonNum
	
	for b in buttons:
		lastButtonNum = int(b.text)
		b.queue_free()
	
	for n in range(lastButtonNum+1,lastButtonNum+25):
		var b = button.instantiate()
		b.text = str(n)
		$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
	pass # Replace with function body.
