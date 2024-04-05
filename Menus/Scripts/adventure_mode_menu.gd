extends Control

const info_text = [
"10 easy levels, plenty of upgrades"
,"15 less challenging levels, more upgrades"
,"A fair selection of 20 levels, with evenly placed upgrades"
,"Harder levels, less upgrades, 25 of them"
,"30 of the toughest levels, fewest upgrades"]
var val = 2

func _ready():
	Global.reset_upgrade_list()
	Global.adventure_mode_level_num = 0
	Global.adventureMode = false
	Global.b_levels_play = Global.b_levels
	Global.e_levels_play = Global.e_levels
	Global.m_levels_play = Global.m_levels
	Global.h_levels_play = Global.h_levels

func _on_h_slider_value_changed(value):
	$MarginContainer/VBoxContainer/MarginContainer2/InfoLabel.text = info_text[value]
	val = value
	pass # Replace with function body.


func _on_back_button_pressed():
	Global.goto_scene("res://Menus/level_selector_menu_menu.tscn")
	pass # Replace with function body.


func _on_play_button_pressed():
	print("will work on this laterrrrr")
	var diff = Global.adventure_mode_difficulty[val]
	print(diff)
	Global.adventure_mode_diff_selected = diff
	Global.adventureMode = true
	var rng = RandomNumberGenerator.new()
	var a = rng.randi_range(0, 70)
	if diff[0] > a and a > 0 :
		Global.current_level = Global.b_levels_play.pick_random()
		Global.b_levels_play.erase(Global.current_level)
		print("beg")
	elif diff[0]+diff[1] > a :
		Global.current_level = Global.e_levels_play.pick_random()
		Global.e_levels_play.erase(Global.current_level)
		print("eas")
	elif diff[0]+diff[1]+diff[2] > a:
		Global.current_level = Global.m_levels_play.pick_random()
		Global.m_levels_play.erase(Global.current_level)
		print("med")
	else :
		Global.current_level = Global.h_levels_play.pick_random()
		Global.h_levels_play.erase(Global.current_level)
		print("hard")
	Global.lives = 3
	Global.goto_scene("res://LevelTools/level.tscn")
	# my idea:
	#have bunch of hard / med / easy levels
	# each difficulty has % assosiciated with each of them, easy -> 60% easy, 30% med 10% hard
	# levels have exits in the wall, level has picked exit, you begin next level where you ended
	# after X rooms, "upgrade room" to increase player stats / health / armour
	# no between level result screen, just load next level
	# switch scene -> ready func picks level -> switch back to level
	pass # Replace with function body.
