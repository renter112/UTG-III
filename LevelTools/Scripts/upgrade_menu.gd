extends Control

var ul
var opt = ["l"]
var o1
var o2
var btn_opts = {"f":"Speed Up","g":"Gun Up", "l":"Life Up", "sa":"Side Armour"}
var lbl_desc = {"f":"Movement Speed & Rotation Increase",
"g":"Bullet Speed Up & Reload Time Down",
"l":"Get An Extra Life",
"sa":"Get Protection from the side"}
func _ready():
	ul = Global.upgrade_list
	if ul.get("gun") <3:
		opt.push_back("g")
	if ul.get("side_armor") < 1:
		opt.push_back("sa")
	if ul.get("speed") < 3:
		opt.push_back("f")
	
	o1 = opt.pick_random()
	opt.erase(o1)
	o2 = opt.pick_random()
	
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button.text = btn_opts.get(o1)
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Button2.text = btn_opts.get(o2)
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label.text = lbl_desc.get(o1)
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Label2.text = lbl_desc.get(o2)
func _on_button_pressed():
	print(o1)
	check_selection(o1)
	pass # Replace with function body.


func _on_button_2_pressed():
	print(o2)
	check_selection(o2)
	pass # Replace with function body.

func check_selection(o):
	if o == "g":
		Global.upgrade_list["gun"] += 1
	elif o == "sa" :
		Global.upgrade_list["side_armor"] = 1
	elif o == "f":
		Global.upgrade_list["speed"] += 1
	elif o == "l":
		Global.lives += 1
	Global.goto_scene("res://LevelTools/level.tscn")
