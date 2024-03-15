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
var osaka_mode_on = false
var shots_taken = 0
var attempts_taken = 0
var time_taken = 0
var level_success = false

var tank_controls_classic = true 
var adventureMode = false
func get_adventureMode():
	return adventureMode
func set_adventureMode(a):
	adventureMode = a
