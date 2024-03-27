extends Node

var current_scene = null

func _ready():
	DiscordSDK.app_id = 1221336911730311238
	print("Discord working: " + str(DiscordSDK.get_is_discord_working()))
	DiscordSDK.state = "Idle"
	DiscordSDK.large_image = "old-icon"
	DiscordSDK.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordSDK.refresh() 
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


var enemies = 0
var shots_taken = 0
var attempts_taken = 0
var time_taken = 0
var level_success = false

var tank_controls_classic = true
var adventureMode = false
var custom_level_on = false
var custom_level_path = ""

var played_game_before = false
var osaka_mode_on = false
var music = true
var music_v = 0
var sounds = true
var sounds_v = 0
var fullScreen = false
var inGame = false


func save_config():
	var config = ConfigFile.new()
	config.set_value("Options","music",music )
	config.set_value("Options","music_v",music_v)
	config.set_value("Options","sounds",sounds)
	config.set_value("Options","sounds_v",sounds_v)
	config.set_value("Options","osaka",osaka_mode_on)
	config.set_value("Options","fullScreen",fullScreen)
	config.set_value("Options","played_before",played_game_before)
	config.set_value("Options","custom_level_path",custom_level_path)
	config.save("user://opt.cfg")

func load_save_config():
	var config = ConfigFile.new()
	var err = config.load("user://opt.cfg")
	if err != OK:
		return
	for opt in config.get_sections():
		music = config.get_value(opt, "music", true)
		music_v = config.get_value(opt, "music_v", 0)
		sounds = config.get_value(opt, "sounds", true)
		sounds_v = config.get_value(opt, "sounds_v", 0)
		osaka_mode_on = config.get_value(opt, "osaka", false)
		played_game_before = config.get_value(opt,"played_before", false)
		fullScreen = config.get_value(opt, "fullScreen", false)
		custom_level_path = config.get_value(opt, "custom_level_path", "")
	update_settings()

func update_settings():
	print("sounds true?: ",sounds)
	print("music true?: ",music)
	print("full? ",fullScreen)
	AudioServer.set_bus_mute(2,not sounds)
	AudioServer.set_bus_mute(1,not music)
	AudioServer.set_bus_volume_db(1,music_v)
	AudioServer.set_bus_volume_db(2,sounds_v)
	if fullScreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



# this is the ultimate level storage device
# the goal is to phase out level, level_dict and levels_cleared
# there will be 2 variables, one for built in levels, one for custom downloaded levels
var levels = []
var custom_levels = []
# this will hold the current array of the loaded level
# click on button 1, = [1.xml, 1, seed, 0/1]
var current_level : Array

# this is used to open the dir and look through the folder
func load_levels():
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
					load_levels_xml(path,file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	load_levels_beaten()
	print(levels)
	levels.sort_custom(func(a, b): return a[1].naturalnocasecmp_to(b[1]) < 0)
	print(levels)

# this is used to read the xml for each level
func load_levels_xml(path,file_name):
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
	levels.push_back([file_name,n,s,0])
	
# this is used to see which of the levels has been beaten
func load_levels_beaten():
	if not FileAccess.file_exists("user://save.save"):
		return
	var save_file = FileAccess.open("user://save.save",FileAccess.READ)
	var levels_beat = []
	while save_file.get_position() < save_file.get_length():
		levels_beat.push_back(save_file.get_line())
	for l in levels:
		if levels_beat.has(l[2]):
			l[3]=1
	pass

func save_levels():
	var save_file = FileAccess.open("user://save.save",FileAccess.WRITE)
	for l in levels:
		if l[3] == 1:
			save_file.store_line(str(l[2]))

func load_custom_levels():
	var dir = DirAccess.open(custom_level_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.ends_with(".xml"):
					load_custom_levels_xml(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	load_custom_levels_beaten()
	
func load_custom_levels_xml(file_name):
	var parser = XMLParser.new()
	var n
	var s
	parser.open(custom_level_path+"/"+file_name)
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
	custom_levels.push_back([file_name,n,s,0])
	
# this is used to see which of the levels has been beaten
func load_custom_levels_beaten():
	if not FileAccess.file_exists("user://custom.save"):
		return
	var save_file = FileAccess.open("user://custom.save",FileAccess.READ)
	var levels_beat = []
	while save_file.get_position() < save_file.get_length():
		levels_beat.push_back(save_file.get_line())
	for l in custom_levels:
		if levels_beat.has(l[2]):
			l[3]=1
	pass

func save_custom_levels():
	var save_file = FileAccess.open("user://custom.save",FileAccess.WRITE)
	for l in custom_levels:
		if l[3] == 1:
			save_file.store_line(str(l[2]))

var t_levels = [
["T1.xml","T1","sfavsygx77z7idix9gyf5y1ipd0x866t",0],
["T2.xml","T2","ei0y6pwxndygw6lk2egg7fh4vwgs72uk",0],
["T3.xml","T3","bxokoc6g0i7q1m485kxoe55i4qvj05g6",0],
["T4.xml","T4","iha8hndy3f4t92i0f6a2yekix9f19jg8",0],
["T5.xml","T5","95ss0ewa6twrrk2bdyr8nrmm2xqmfzmz",0],
["T6.xml","T6","2zqrfrbbjosda2mzzxolnarwu76ksdwv",0],
["T7.xml","T7","38ounj0t87hker1274k6r3c8035jbech",0],
["T8.xml","T8","6mjj5rapb9hvi28sei2rcmr9g4ano4fd",0]
]
