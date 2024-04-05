extends Control

var ul
var opt = ["Extra Life"]
var o1
var o2
func _ready():
	ul = Global.upgrade_list
	if ul.get("gun") <3:
		opt.push_back("Better Gun")
	if ul.get("side_armor") < 1:
		opt.push_back("Side Armour")
	if ul.get("speed") < 3:
		opt.push_back("Faster Speed")
	
	o1 = opt.pick_random()
	opt.erase(o1)
	o2 = opt.pick_random()
	
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Button.text = o1
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Button2.text = o2

func _on_button_pressed():
	print(o1)
	check_selection(o1)
	pass # Replace with function body.


func _on_button_2_pressed():
	print(o2)
	check_selection(o2)
	pass # Replace with function body.

func check_selection(o):
	if o == "Better Gun":
		Global.upgrade_list["gun"] += 1
	elif o == "Side Armour" :
		Global.upgrade_list["side_armor"] = 1
	elif o == "Faster Speed":
		Global.upgrade_list["speed"] += 1
	elif o == "Extra Life":
		Global.lives += 1
	Global.goto_scene("res://LevelTools/level.tscn")
