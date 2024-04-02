extends Control

const info_text = [
"Easier levels, plenty of upgrades"
,"Less challenging levels, more upgrades"
,"A fair selection of levels, with evenly placed upgrades"
,"Harder levels, less upgrades"
,"The toughest levels, few upgrades"]


func _on_h_slider_value_changed(value):
	$MarginContainer/VBoxContainer/MarginContainer2/InfoLabel.text = info_text[value]
	pass # Replace with function body.


func _on_back_button_pressed():
	Global.goto_scene("res://Menus/level_selector_menu_menu.tscn")
	pass # Replace with function body.


func _on_play_button_pressed():
	print("will work on this laterrrrr")
	# my idea:
	#have bunch of hard / med / easy levels
	# each difficulty has % assosiciated with each of them, easy -> 60% easy, 30% med 10% hard
	# levels have exits in the wall, level has picked exit, you begin next level where you ended
	# after X rooms, "upgrade room" to increase player stats / health / armour
	# no between level result screen, just load next level
	# switch scene -> ready func picks level -> switch back to level
	pass # Replace with function body.
