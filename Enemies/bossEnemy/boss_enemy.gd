extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet_big.tscn")

func _ready():
	tank =  get_node("../tank_hull")
	$RayCast2D.add_exception(tank)
	pass
	
func _process(delta):
	$turret.rotation = (tank.position - position).angle()
	$RayCast2D.target_position = tank.position - position
	if $Timer.is_stopped() && $RayCast2D.is_colliding() != true:
			shoot()
			$Timer.start(1.5)

func shoot():
	var b = bullet.instantiate()
	var b2 = bullet.instantiate()
	get_tree().get_root().get_node("/root/level").add_child(b)
	get_tree().get_root().get_node("/root/level").add_child(b2)
	b.transform = $turret/Marker2D.global_transform
	b2.transform = $turret/leftMarker2D.global_transform
