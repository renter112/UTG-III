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
			$Timer.start(3.0)

func shoot():
	var b = bullet.instantiate()
	var b2 = bullet.instantiate()
	var b3 = bullet.instantiate()
	get_tree().get_root().add_child(b)
	get_tree().get_root().add_child(b2)
	get_tree().get_root().add_child(b3)
	var theta = PI / 6
	b.transform = $turret/marker_middle.global_transform
	b2.transform = $turret/marker_left.global_transform#.rotated(PI /6)
	b3.transform = $turret/marker_right.global_transform#.rotated(-PI / 6)

