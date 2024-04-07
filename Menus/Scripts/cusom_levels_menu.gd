extends Control

var custom_levels
var btn_c
var ntf_lbl
var info_c
# Called when the node enters the scene tree for the first time.
func _ready():
	btn_c = get_node("MarginContainer/VBoxContainer2/HBoxContainer2/MarginContainer2/ScrollContainer/VBoxContainer")
	ntf_lbl = get_node("MarginContainer/VBoxContainer2/HBoxContainer2/MarginContainer2/Label")
	info_c = get_node("MarginContainer/VBoxContainer2/HBoxContainer2/MarginContainer/VBoxContainer")
	Global.load_custom_levels()
	create_buttons()
	pick_random()
	pass # Replace with function body.

func pick_random():
	if not Global.custom_levels.is_empty():
		var buttons = btn_c.get_children()
		var button = buttons.pick_random()
		print(button)
		button.emit_signal("pressed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func create_buttons():
	if Global.custom_levels.is_empty():
		info_c.visible = false
		ntf_lbl.visible = true
		return
	info_c.visible = true
	ntf_lbl.visible = false
	
	for level in Global.custom_levels:
		var level_button = preload("res://Menus/Assets/custom_level_button.tscn").instantiate()
		level_button.level_to_load = level
		level_button.text = str(level[1])
		btn_c.add_child(level_button)



func clear_buttons():
	var bs = btn_c.get_children()
	for b in bs:
		b.queue_free()


func _on_button_pressed():
	$FileDialog.visible = true
	pass # Replace with function body.



func _on_back_button_pressed():
	Global.goto_scene("res://Menus/level_selector_menu_menu.tscn")
	pass # Replace with function body.


func _on_file_dialog_files_selected(paths):
	Global.move_to_custom(paths)
	Global.load_custom_levels()
	clear_buttons()
	create_buttons()
	pick_random()
	pass # Replace with function body.


func _on_play_button_pressed():
	Global.custom_level_on = true
	if not Global.current_level.is_empty():
		Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.


func _on_delete_button_pressed():
	var dir = DirAccess.open("user://levels/")
	dir.remove(Global.current_level[0])
	Global.custom_levels = []
	clear_buttons()
	Global.load_custom_levels()

	create_buttons()
	pick_random()
	pass # Replace with function body.


func _on_button_2_pressed():
	clear_buttons()
	Global.load_custom_levels()
	create_buttons()
	pick_random()
	pass # Replace with function body.
