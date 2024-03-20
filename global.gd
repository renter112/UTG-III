extends Node

var current_scene = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
var level = 1 as int
func get_level():
	return level
func set_level(lvl):
	level = lvl



var enemies = 0
var shots_taken = 0
var attempts_taken = 0
var time_taken = 0
var level_success = false

var tank_controls_classic = true
 
var osaka_mode_on = false
var adventureMode = false
var music = true
var sounds = true
var fullScreen = false


var levels_cleared = []
func get_levels_from_save():
	if not FileAccess.file_exists("user://save.save"):
		return
	var save_file = FileAccess.open("user://save.save",FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var seed = save_file.get_line()
		for l in level_dict:
			if level_dict[l][1] == seed:
				levels_cleared.push_back(level_dict[l][0].get_basename())
	pass
func save_levels_beaten():
	var save_file = FileAccess.open("user://save.save",FileAccess.WRITE)
	for level in levels_cleared:
		var level_n = str(level)+".xml"
		save_file.store_line(str(level_dict[level_n][1]))

var level_dict = {}
func load_level_dict():
	var path = "res://LevelTools/levels"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.ends_with(".xml"):
					check_xml(path,file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
func check_xml(path,file_name):
	var parser = XMLParser.new()
	var n
	var s
	parser.open(path+"/"+file_name)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if(node_name == "levelName"):
				n = attributes_dict["name"]
			elif(node_name == "levelSeed"):
				s = attributes_dict["seed"]
	level_dict[file_name] = [n,s]
