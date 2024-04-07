extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet_ghost.tscn")

func _ready():
	tank =  get_node("../tank_hull")
	pass
	
func _process(_delta):
	$turret.rotation = (tank.position - position).angle()
	if $Timer.is_stopped():
			shoot()
			$Timer.start(3.0)

func shoot():
	var b = bullet.instantiate()
	get_tree().get_root().get_node("/root/level").add_child(b)
	b.transform = $turret/Marker2D.global_transform
