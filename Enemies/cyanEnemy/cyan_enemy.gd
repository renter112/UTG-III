extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet_ghost.tscn")

func _ready():
	tank =  get_node("../tank_hull")
	pass
	
func _process(delta):

	if $Timer.is_stopped():
			$turret.rotation = (tank.position - position).angle()
			shoot()
			$Timer.start(3.0)

func shoot():
	var b = bullet.instantiate()
	get_tree().get_root().add_child(b)
	b.transform = $turret/Marker2D.global_transform
