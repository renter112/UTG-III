extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet.tscn")
var movement_speed: float = 120
var movement_target_position: Vector2

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	tank =  get_node("../tank_hull")
	$RayCast2D.add_exception(tank)
	nav.target_position = tank.global_position
	pass
	
func _process(delta):
	$RayCast2D.target_position = tank.global_position - global_position
	$turret.rotation = (tank.position - position).angle()
	if $Timer.is_stopped() && $RayCast2D.is_colliding() != true:
		shoot()
		$Timer.start(2.0)

func shoot():
	var b = bullet.instantiate()
	get_tree().get_root().get_node("/root/level").add_child(b)
	b.transform = $turret/Marker2D.global_transform



func _physics_process(delta):
	if nav.distance_to_target() < 30.0:
		nav.target_position = tank.global_position
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	$enemyhull.rotation = direction.angle()
	$CollisionShape2D.rotation = direction.angle()
	velocity = velocity.lerp(direction * movement_speed, 7*delta)
	move_and_slide()
