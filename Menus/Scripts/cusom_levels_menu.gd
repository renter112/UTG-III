extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	dir_contents("res://LevelTools/levels")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.ends_with(".xml"):
					check_xml(path,file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func check_xml(path,file_name):
	var level_button = preload("res://Menus/Assets/custom_level_button.tscn").instantiate()
	var parser = XMLParser.new()
	parser.open(path+"/"+file_name)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			print(level_button)
			if(node_name == "levelName"):
				print(attributes_dict["name"])
				level_button.text = attributes_dict["name"]
			if(node_name == "levelSeed"):
				print(attributes_dict["seed"])
	$ScrollContainer/VBoxContainer.add_child(level_button)
			#print("The ", node_name, " element has the following attributes: ", attributes_dict)


func _on_v_scroll_bar_scrolling():
	pass # Replace with function body.
