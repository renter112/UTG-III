extends CharacterBody2D

var tank
var bullet = preload("res://Enemies/miniEnemy/mini_tank.tscn")

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	tank =  get_node("../tank_hull")
	nav.target_position = tank.global_position
	pass
	
func _process(delta):
	nav.target_position = tank.global_position
	$turret.rotation = ( nav.get_next_path_position() - global_position).angle()
	if $Timer.is_stopped():
			shoot()
			$Timer.start(5.0)

func shoot():
	var b = bullet.instantiate()
	b.transform = $turret/Marker2D.global_transform
	b.scale = Vector2(1.5,1.5)
	get_tree().get_root().get_node("/root/level").add_child(b)
