extends Control

var custom_levels
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.custom_level_on = true
	Global.load_custom_levels()
	create_buttons()
	pick_random()
	pass # Replace with function body.

func pick_random():
	var buttons = $MarginContainer/VBoxContainer2/HBoxContainer2/MarginContainer2/ScrollContainer/VBoxContainer.get_children()
	var button = buttons.pick_random()
	button.emit_signal("pressed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func create_buttons():
	for level in Global.custom_levels:
		var level_button = preload("res://Menus/Assets/custom_level_button.tscn").instantiate()
		level_button.level_to_load = level
		level_button.text = str(level[1])
		$MarginContainer/VBoxContainer2/HBoxContainer2/MarginContainer2/ScrollContainer/VBoxContainer.add_child(level_button)



func clear_buttons():
	var bs = $MarginContainer/VBoxContainer2/HBoxContainer2/MarginContainer2/ScrollContainer/VBoxContainer.get_children()
	for b in bs:
		b.queue_free()


func _on_button_pressed():
	$FileDialog.visible = true
	pass # Replace with function body.


func _on_file_dialog_dir_selected(dir):
	print(dir)
	Global.custom_level_path = dir
	Global.save_config()
	$MarginContainer/VBoxContainer2/MarginContainer/Label.text = "Current Dir: "+Global.custom_level_path
	Global.custom_levels = []
	clear_buttons()
	Global.load_custom_levels()
	create_buttons()
	pass # Replace with function body.


func _on_back_button_pressed():
	Global.goto_scene("res://Menus/level_selector_menu_menu.tscn")
	pass # Replace with function body.


func _on_file_dialog_files_selected(paths):
	Global.move_to_custom(paths)
	Global.load_custom_levels()
	clear_buttons()
	create_buttons()
	pass # Replace with function body.


func _on_play_button_pressed():
	Global.custom_level_on = true
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.
