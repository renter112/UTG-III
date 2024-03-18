extends Control

var button = preload("res://Menus/Assets/button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.attempts_taken = 0
	Global.shots_taken = 0
	Global.time_taken = 0
	for n in range(1,25):
		var b = button.instantiate()
		b.text = str(n)
		$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
	pass # Replace with function body.


func _on_return_button_pressed():
	Global.goto_scene("res://Menus/main_menu.tscn")
	pass # Replace with function body.



func _on_back_button_pressed():
	var buttons = $MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.get_children()
	var lastButtonNum
	var minLevel = 1
	
	for b in buttons:
		lastButtonNum = int(b.text)
	
	if lastButtonNum >= minLevel + 24:
		for b in buttons:
			b.queue_free()
	
		for n in range(lastButtonNum+1,lastButtonNum+25):
			var b = button.instantiate()
			b.text = str(n-48)
			$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
	
	pass # Replace with function body.


func _on_forward_button_pressed():
	var buttons = $MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.get_children()
	var lastButtonNum
	var maxLevel = 48
	
	for b in buttons:
		lastButtonNum = int(b.text)
		
	if lastButtonNum <= maxLevel - 24:
		for b in buttons:
			b.queue_free()
		
		for n in range(lastButtonNum+1,lastButtonNum+25):
			var b = button.instantiate()
			b.text = str(n)
			$MarginContainer/CenterContainer/HBoxContainer/MarginContainer/CenterContainer/GridContainer.add_child(b)
			
	pass # Replace with function body.
