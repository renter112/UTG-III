extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet.tscn")

func _ready():
	tank =  get_node("../tank_hull")
	$RayCast2D.add_exception(tank)
	pass
	
func _process(delta):
	$turret.rotation = (tank.position - position).angle()
	$RayCast2D.target_position = tank.position - position
	if $Timer.is_stopped() && $RayCast2D.is_colliding() != true:
			shoot()
			$Timer.start(2.0)

func shoot():
	var b = bullet.instantiate()
	get_tree().get_root().add_child(b)
	b.transform = $turret/Marker2D.global_transform

