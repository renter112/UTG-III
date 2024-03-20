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
		levels_cleared.push_back(save_file.get_line())
	pass
func save_levels_beaten():
	var save_file = FileAccess.open("user://save.save",FileAccess.WRITE)
	for level in levels_cleared:
		save_file.store_line(str(level))
