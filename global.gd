extends Node

var current_scene = null

func _ready():
	get_viewport().files_dropped.connect(on_files_dropped)
	DiscordSDK.app_id = 1221336911730311238
	print("Discord working: " + str(DiscordSDK.get_is_discord_working()))
	DiscordSDK.state = "Idle"
	DiscordSDK.large_image = "old-icon"
	DiscordSDK.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordSDK.refresh() 
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	load_save_config()
	load_levels()
	
func on_files_dropped(files):
	move_to_custom(files)

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
var custom_level_on = false
var level_err = false
var notif_message = false
var played_game_before = false
var osaka_mode_on = false
var music = true
var music_v = 0
var sounds = true
var sounds_v = 0
var fullScreen = false
var inGame = false
var camera_zoom = Vector2(1,1)

var adventureMode = false
var adventure_mode_level_num = 0
# easy % , med %, hard %, item room every X
var adventure_mode_difficulty = [[80,20,0,3,10],[40,40,20,4,10],[30,40,30,5,15],[25,35,40,6,20],[10,10,80,7,25],[0,0,100,10,50]]
var adventure_mode_diff_selected : Array

var lives = 1
var upgrade_list = {"gun":0,"speed":0,"side_armor":0}
func reset_upgrade_list():
	upgrade_list = {"gun":0,"speed":0,"side_armor":0}


func save_config():
	var config = ConfigFile.new()
	config.set_value("Options","music",music )
	config.set_value("Options","music_v",music_v)
	config.set_value("Options","sounds",sounds)
	config.set_value("Options","sounds_v",sounds_v)
	config.set_value("Options","osaka",osaka_mode_on)
	config.set_value("Options","fullScreen",fullScreen)
	config.set_value("Options","played_before",played_game_before)
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
				if file_name.ends_with(".utg2"):
					load_levels_xml(path,file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	load_levels_beaten()
	levels.sort_custom(func(a, b): return a[1].naturalnocasecmp_to(b[1]) < 0)


# this is used to read the xml for each level
func load_levels_xml(path,file_name):
	var parser = XMLParser.new()
	var n = "LEVEL_NAME_BAD"
	var s = "SEED_BAD"
	parser.open(path+"/"+file_name)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if(node_name == "levelName"):
				if attributes_dict.has("name"):
					n = attributes_dict["name"]
			elif(node_name == "levelSeed"):
				if attributes_dict.has("seed"):
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
	custom_levels.clear()
	var dir_check = DirAccess.open("user://")
	if not dir_check.dir_exists("levels"):
		dir_check.make_dir("user://levels")
	var dir = DirAccess.open("user://levels/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.ends_with(".utg2"):
					print(file_name)
					load_custom_levels_xml(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	load_custom_levels_beaten()
	
func load_custom_levels_xml(file_name):
	var parser = XMLParser.new()
	var n = "Level Name"
	var s = "11111111"
	var a = "UTG-2"
	parser.open("user://levels/"+file_name)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if(node_name == "levelName"):
				if attributes_dict.has("name"):
					n = attributes_dict["name"]
			elif(node_name == "levelSeed"):
				if attributes_dict.has("seed"):
					s = attributes_dict["seed"]
			elif node_name == "author":
				if attributes_dict.has("user"):
					a = attributes_dict["user"]
	custom_levels.push_back([file_name,n,s,"",a])
# this is used to see which of the levels has been beaten
func load_custom_levels_beaten():
	if not FileAccess.file_exists("user://custom.save"):
		return
	var save_file = FileAccess.open("user://custom.save",FileAccess.READ)
	var levels_beat = {}
	while save_file.get_position() < save_file.get_length():
		var vals = save_file.get_line().split(" ")
		levels_beat[vals[0]] = vals[1]
		
	for l in custom_levels:
		if levels_beat.has(l[2]):
			l[3]= levels_beat.get(l[2])
	pass

func save_custom_levels():
	var save_file = FileAccess.open("user://custom.save",FileAccess.WRITE)
	for l in custom_levels:
		if not l[3].is_empty():
			save_file.store_line(str(l[2]) + " " + str(l[3]))

func move_to_custom(files):
	var check = DirAccess.open("user://")
	if not check.dir_exists("levels"):
		check.make_dir("user://levels")
	for file in files:
		if file.ends_with(".utg2"):
			var safety = check_file_goodness(file)
			if safety == "SAFE":
				var save_file = FileAccess.open(str("user://levels/",file.get_file()),FileAccess.WRITE)
				var file_open = FileAccess.open(file,FileAccess.READ)
				while file_open.get_position() < file_open.get_length():
					save_file.store_line(file_open.get_line())
			else:
				print("ERROR IN LOAD: ",safety)
				push_notif("ERROR LOADING: "+safety)
				return
	push_notif("IMPORTED SUCCESSFULLY")

func check_file_goodness(file):
	var parser = XMLParser.new()
	parser.open(file)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var att_dict = {}
			for idx in range(parser.get_attribute_count()):
				att_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if node_name == "grid":
				if not att_dict.has("x") or not att_dict.has("y"):
					return "ERR GRID"
			elif node_name == "coord":
				if not att_dict.has("type") or not att_dict.has("x") or not att_dict.has("y"):
					return "ERR COORD"
			elif node_name == "player":
				if not att_dict.has("type") or not att_dict.has("x") or not att_dict.has("y"):
					return "ERR PLAYER"
			elif node_name == "turret":
				if not att_dict.has("type") or not att_dict.has("y") or not att_dict.has("x"):
					return "ERR TURRET"
			elif node_name == "tank":
				if not att_dict.has("type") or not att_dict.has("y") or not att_dict.has("x"):
					return "ERR TANK"
	return "SAFE"

func push_notif(msg):
	notif_message = msg
	var notif = load("res://Menus/Assets/import_notification.tscn")
	var notif2 = notif.instantiate() 
	get_tree().root.add_child.call_deferred(notif2)

var levels_to_print = []
func print_level_array():
	var path = "res://LevelTools/AdventureLevels/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.ends_with(".utg2"):
					print_levels_xml(path,file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	levels_to_print.sort_custom(func(a, b): return a[1].naturalnocasecmp_to(b[1]) < 0)


# this is used to read the xml for each level
func print_levels_xml(path,file_name):
	var parser = XMLParser.new()
	var n = "LEVEL_NAME_BAD"
	var s = "SEED_BAD"
	parser.open(path+"/"+file_name)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if(node_name == "levelName"):
				if attributes_dict.has("name"):
					n = attributes_dict["name"]
			elif(node_name == "levelSeed"):
				if attributes_dict.has("seed"):
					s = attributes_dict["seed"]
	levels_to_print.push_back([file_name,n,s,0])



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

var e_levels = [
["e1.utg2", "e1", "f9mud03zstwztylj8pugibyrs8415hu8", 0], 
["e2.utg2", "e2", "7796rwc27j63gugayza1qlit0txmnvpo", 0], 
["e3.utg2", "e3", "popyueq2v892ipey5svyijj35n46a708", 0], 
["e4.utg2", "e4", "bh4yd2u1esgbj513xmzph3wx7sl7njja", 0], 
["e5.utg2", "e5", "qpc4zbj8o0hhd2cqawnchdovhwjzi8lq", 0], 
["e6.utg2", "e6", "b6lq45fuqhs9ym3s83b0k7jqm9h0w8u2", 0], 
["e7.utg2", "e7", "feebdsw67z6zfbqc7wl6eyb59uk06wm6", 0], 
["e8.utg2", "e8", "kb077eb9muepyktrtosmej9om01kifo4", 0], 
["e9.utg2", "e9", "kfs523nlajmeuqaayi13afhtww8nc5pq", 0], 
["e10.utg2", "e10", "pyilxgrjzqp8f0pddom1xpi77w2g9p5k", 0], 
["e11.utg2", "e11", "cj8xxgz87mimeobwz94skdjn9lez7vmq", 0], 
["e12.utg2", "e12", "i278tkj4rpua4fk9svlhiqo34if8shbj", 0], 
["e13.utg2", "e13", "eem7sygtk0kj2xyqyy5txiydp006hmee", 0], 
["e14.utg2", "e14", "l2mihakxu1cj0afu5u7zx59o8imqb425", 0], 
["e15.utg2", "e15", "j2p9um59zat6eqp0tlcriyegv9mynqmk", 0], 
["e16.utg2", "e16", "6bgmcjwnkte5qwy73inaqgb9ymnxr01n", 0], 
["e17.utg2", "e17", "vuvrtziqcyqlmh2qlsel8suqp5wg9juw", 0], 
["e18.utg2", "e18", "0ukagmf6v47ivea4o1xhpkb1e3zxhwdf", 0], 
["e19.utg2", "e19", "c2o2pklhlw9dpc8qmgv6q3nw9krnntrm", 0], 
["e20.utg2", "e20", "xuwd92bim79c27oul3datwfrjn0rtzm2", 0], 
["e21.utg2", "e21", "boh8hivufd949ypu53jb4ay17yrykr1r", 0], 
["e22.utg2", "e22", "d90g385nrngfv0h85dk5yklb49cmo3na", 0], 
["e23.utg2", "e23", "maxjuny6rerc09afa59nym3hsjvepj7g", 0], 
["e24.utg2", "e24", "160dnrva3bqtw5vieh8wyzcwhsxhr596", 0], 
["e25.utg2", "e25", "utete0mgomdsb7wfvtt3134j9miimt2g", 0], 
["e26.utg2", "e26", "17b4l9hex0du9mxlrpuwktqsguvleyxt", 0], 
["e27.utg2", "e27", "wjw896logi2dejktzvhn6jsgeklsabt6", 0], 
["e28.utg2", "e28", "v7bmrmsc6ypnnajpzifubtnwki0rhows", 0], 
["e29.utg2", "e29", "glvb344jkdsu3o61c47v86o7o8v2v9d4", 0], 
["e30.utg2", "e30", "s94wsquicppybtx6gbkna9hkz0y8dcvu", 0], 
["e31.utg2", "e31", "6mhpu7449vwneuv97ndb6rkcmcto3201", 0], 
["e32.utg2", "e32", "469m024iiq9h6joiz0ak06odog3m0aqe", 0], 
["e33.utg2", "e33", "3883d4rk5q9hffpx4ysynrvpc0jbbyx3", 0], 
["e34.utg2", "e34", "2gz7rgs5qk0908utpg6z6uzwe4gvcewz", 0], 
["e35.utg2", "e35", "hp6jo74m07juh1n5j2kuuaen7295k1ug", 0], 
["e36.utg2", "e36", "4ocec57j20szfv5qtzkym5ya03qwsquy", 0], 
["e37.utg2", "e37", "jqqhw65xcxag8i4ahx0wb2kwie14pu7f", 0], 
["e38.utg2", "e38", "wdbqbvmtya7uk6sm07kv0xzkequ8noob", 0], 
["e39.utg2", "e39", "6but3gum0qvh8awevhpkal5mkw70n3zy", 0], 
["e40.utg2", "e40", "jygh7p291nl8fgxqnou6exuys00in64w", 0], 
["e41.utg2", "e41", "afc1mblb2iqeaehy8h4om9priplfhk0x", 0], 
["e42.utg2", "e42", "tfslos9x4g822exn40rw6e89nxoh6gvt", 0], 
["e43.utg2", "e43", "mycy5rn0umztdrz2699vge372p2uyoiw", 0], 
["e44.utg2", "e44", "537xo6pc797yqekca89t7rspvpdxyvv3", 0], 
["e45.utg2", "e45", "4t1p83m712qqsregecchwse9u47u9a5c", 0], 
["e46.utg2", "e46", "4g44oa3rgecap7l6sl22s5tjkusalebb", 0], 
["e47.utg2", "e47", "agqf4a477rh06571ktlrht6pcy98j3zc", 0], 
["e48.utg2", "e48", "zbym5cppcgsz93ksad8t3kfurv1os35d", 0], 
["e49.utg2", "e49", "i9o5w3fmkemn76msv1tcrugv8n2n30et", 0], 
["e50.utg2", "e50", "d38vqbkhu2zoqg7q0ayr1wiohe9fl0jl", 0]]
var m_levels = [
["m1.utg2", "m1", "d7jmz8qsz523jhje6wcld2eioe6s5gp8", 0], 
["m2.utg2", "m2", "cusscqkp2rxmlwxj4nw0atjlk8h6zywd", 0], 
["m3.utg2", "m3", "wsx8lyu3tsrbfozlxx70qi04k2om4xw2", 0], 
["m4.utg2", "m4", "jbm13hj2kikdmbfybe5jgqeedu3ohfyh", 0], 
["m5.utg2", "m5", "n9dzrz8lmfqxu6nrqgx8zeq4jzexjvk7", 0],
["m6.utg2", "m6", "11bzgmdyypdpz46fmc5g4f8kry6fuzxn", 0], 
["m7.utg2", "m7", "7ybyiujn9we1jb7byn20is0olhljfjh2", 0], 
["m8.utg2", "m8", "y0idapd7xvbqejzix1zr9ra8uhx3kx4l", 0], 
["m9.utg2", "m9", "1lpzp52gu83r2ro7f4scj54k1opu24p0", 0], 
["m10.utg2", "m10", "6ojy0w2gzby6lmtuuct44azugiij2vr7", 0], 
["m11.utg2", "m11", "sc0ibpahb6hqil0bgh5lhjzv5xylkrem", 0], 
["m12.utg2", "m12", "lz7dfk0fisdes47eyl4qp1cxj3mylu8w", 0], 
["m13.utg2", "m13", "ejuybjc9u8q1xnikrzt1p6wbkp0fydke", 0], 
["m14.utg2", "m14", "sayf6txdx8k9e3in805pc5igrs4oob4o", 0], 
["m15.utg2", "m15", "ofv51g8kcujcwu0gc5wnvy3ldvz8wb3v", 0], 
["m16.utg2", "m16", "j4k1pn13aebm7aobdc9n84ha8cadyb6b", 0], 
["m17.utg2", "m17", "ca0pro0f3jbaai6q4c9u1rep65la6vld", 0], 
["m18.utg2", "m18", "rshw7j5i24yta0wabotvo5m8vgg2sqbg", 0], 
["m19.utg2", "m19", "jarsofxpubmyd7in0b99pbdgbp01amh2", 0], 
["m20.utg2", "m20", "ty2y4n0so7ppu2tv36egseewk7qj5g5c", 0], 
["m21.utg2", "m21", "ffbhkpxk6eed6ibd6tuhmwjrkbl4j05p", 0], 
["m22.utg2", "m22", "t4zx4lmd7lqcorsosjqdjciw7n3qclyd", 0], 
["m23.utg2", "m23", "w1sd9i1pwmk0pj61q1ocrojaezo25bbk", 0],
["m24.utg2", "m24", "856p18mwpcs19t39vvtvs12o3t7r02uq", 0], 
["m25.utg2", "m25", "7nhuqdd0015a03tjmolzjl1883rsko0a", 0], 
["m26.utg2", "m26", "3o1ljlz5d2czgtocsrdth974tvxz5k6n", 0], 
["m27.utg2", "m27", "3vp8gbh0b8mf3p6ew3j9bdrcyn4zc8qt", 0], 
["m28.utg2", "m28", "9chh6r9qopd7y3k68bbn9gbohfac6dmn", 0], 
["m29.utg2", "m29", "scd9n3n1erj070j265mkhbvru72k692q", 0], 
["m30.utg2", "m30", "6lmjtlegrf8xi3cqslcdtulp7sejepdw", 0], 
["m31.utg2", "m31", "6ks60046v5ec03aidazj0lt4irk13gxv", 0], 
["m32.utg2", "m32", "obg0h9jewavj296hiby7jqy1z2ivatc4", 0], 
["m33.utg2", "m33", "0dgj29vwrs05drjtcgxswoyxdnp2zkf4", 0], 
["m34.utg2", "m34", "pk2nmfodpo78d4rlbspak4cu6fy234sl", 0], 
["m35.utg2", "m35", "r8m3z6epfu2yemjkgun73iw1iqyai958", 0], 
["m36.utg2", "m36", "old219eh0i3zr5in9ssxeyzgoybnh13b", 0], 
["m37.utg2", "m37", "td2bihf1oy8v5pc7m81gz8zjw5xpo6z1", 0], 
["m38.utg2", "m38", "2miwon3y31rh694c6jlsvtmxn69029b7", 0], 
["m39.utg2", "m39", "xm9xkhqzk0vqn2wo6kqyc0cqi3usj6rb", 0], 
["m40.utg2", "m40", "n7r7sxwf0cwxjgunshvlefjv6snkg7dq", 0],
["m41.utg2", "m41", "dok3m8d6rshe3m79o9idhcjca8lw5g3p", 0], 
["m42.utg2", "m42", "gjr2dclex27sczv3miz942elcgkptb9g", 0], 
["m43.utg2", "m43", "7yju8o2jovd7tghd5cotn3z5gdlgyqqp", 0], 
["m44.utg2", "m44", "zn91lobnlmte1vh3akj9sp1k2iwm47w1", 0], 
["m45.utg2", "m45", "mzwl6x3675wl0441r03r81kie5yrc4t1", 0], 
["m46.utg2", "m46", "kaw4muds05y2rlm0tz2xrhyqod06944k", 0], 
["m47.utg2", "m47", "wdk5atig11wzs75565k6824l9fyn85dm", 0], 
["m48.utg2", "m48", "q7ffrdgm6gkwhuls57edyor7woswnh7d", 0], 
["m49.utg2", "m49", "0jiov3j4wwmtqqc27elc9ekr4i0ewzqv", 0], 
["m50.utg2", "m50", "gyzjfekyx4l1k9vnrz355gafem1yysmu", 0]]
var h_levels = [
["h1.utg2", "h1", "ch82qjcb128qkwyfbni9zob1mgke8v68", 0], 
["h2.utg2", "h2", "2vcwik7jw21f59q8wo0uak97p1k2xwjd", 0], 
["h3.utg2", "h3", "p9mdn8d62f1old8w6jihxei5hdxkqdk8", 0], 
["h4.utg2", "h4", "x8y0j0bfxi7q8z65oef1lddo4nh7bj8d", 0], 
["h5.utg2", "h5", "jernnrij2vc1bbzk6l2wszot7hqj0qub", 0],
["h6.utg2", "h6", "red8iud9kll3yq6e5nvn9crleboa4337", 0], 
["h7.utg2", "h7", "qcp44lq0aj432gp1b4frm3qni7cyrsqt", 0], 
["h8.utg2", "h8", "k6mc4z29urkxrcsurf7bh2u8hyw38pbv", 0], 
["h9.utg2", "h9", "fa6amptcij8n7yltv9s5civng3452rsr", 0], 
["h10.utg2", "h10", "nixb3z90xwdpkmlfqqf4hu4xpkn14gsv", 0], 
["h11.utg2", "h11", "8djzzpiauh5g1zuqiu19mgadq1fei511", 0], 
["h12.utg2", "h12", "m6hzsgwcfw3r2dufhexyjad6z0lpnwki", 0], 
["h13.utg2", "h13", "2tp5183t00il3gi49c9iawkaxndnos27", 0], 
["h14.utg2", "h14", "b6qyhvhtbb12mgjxs1smqcu7gxmzdf26", 0], 
["h15.utg2", "h15", "ajzw2ug3lvpzj19zfxl1abwpuelz0h62", 0], 
["h16.utg2", "h16", "0sic9ae165tmuh4acil50zcf1mkp52g3", 0], 
["h17.utg2", "h17", "i6hh5ny70ngklnqfw8epp1fz8tvp8dan", 0], 
["h18.utg2", "h18", "x271r7ag6508j5bga2ljr1aq2qcxg2jr", 0], 
["h19.utg2", "h19", "uvbr2q6snvls5dhj7519m6owmv49c5vp", 0], 
["h20.utg2", "h20", "f0ce6cu70gzc3h3elzhvef8wi871dn5c", 0], 
["h21.utg2", "h21", "5wg9a3itasak69rx4knqzauk2s7mucz4", 0], 
["h22.utg2", "h22", "80o8ro6dldjdmigh9htk0xuxa5jzei5j", 0], 
["h23.utg2", "h23", "0vy53pjp7mvcxf6wuajt6me81ifn27vs", 0], 
["h24.utg2", "h24", "8gtr3vce7lrs9s9b1bocep00xmvssdpe", 0], 
["h25.utg2", "h25", "xt85tdbflgm14vwec1g1uyhl8xzakliy", 0], 
["h26.utg2", "h26", "zkvllkztq3lnua6k8ghg92tahocag2xa", 0], 
["h27.utg2", "h27", "rrzwo6tfdx5ui409qqmd1pnk2y6gtw0k", 0], 
["h28.utg2", "h28", "pvmwu3ii2pqk7j3n45mc6x4q810e6dpg", 0], 
["h29.utg2", "h29", "b1mmb45vq80dm2betyv0sm973q2hpp6r", 0], 
["h30.utg2", "h30", "o81854xco2eph27vbr8ma2nkkaepu2pz", 0], 
["h31.utg2", "h31", "kaj0p5qnsn3bb4rch09eeietxul6xatx", 0], 
["h32.utg2", "h32", "qev8f3t8a9r4kfdykasjkrg2zwbsbi5n", 0], 
["h33.utg2", "h33", "b02m2paaf596wpd5plcbtno63oxsi5kq", 0], 
["h34.utg2", "h34", "9ebbkuppar9sz5fo08ixvana0fah8yzf", 0], 
["h35.utg2", "h35", "zpsdcrhl21jb7hn0nnc6jxrfpnslp9su", 0], 
["h36.utg2", "h36", "qk6ht524bnrtdem64brrzybwxfk0arf3", 0], 
["h37.utg2", "h37", "3kweu8ieu9kmoelacu7morp4igtsojz7", 0], 
["h38.utg2", "h38", "uatj7qxjmuw4r1ieduhsp7vchic1mysd", 0], 
["h39.utg2", "h39", "0cgaxf8yccq7xsxey38vliaiaahk6e5u", 0], 
["h40.utg2", "h40", "2n3f3wpdngkfw3h9wrnip1avbcp0oub3", 0], 
["h41.utg2", "h41", "ctutj5y5je8pwn448061e3q0pxuedd3r", 0], 
["h42.utg2", "h42", "pnab49sbe86oxupr1y3lt4d9znpfwd6g", 0], 
["h43.utg2", "h43", "i7d1ji8z62c7h4twqflojeodoswf1hq1", 0], 
["h44.utg2", "h44", "78abotif63w6sku92c5c17uulwad3dhw", 0], 
["h45.utg2", "h45", "272krqgnsaurf2exjx1k38hzfo44pata", 0], 
["h46.utg2", "h46", "76ns1v6662m90zxxssj1qualf5pp6szr", 0], 
["h47.utg2", "h47", "a4mmymn73lmkavrhxmi21vuwh0j70q87", 0], 
["h48.utg2", "h48", "3lgr0q8cyjqduwf6a3e7fz3adqqln0ru", 0], 
["h49.utg2", "h49", "138q9w4acicwhyppj6w2y3qap1yi15m6", 0], 
["h50.utg2", "h50", "bd8a2vckyk3no1ssn2k52jjz0soy0wu6", 0]] 
