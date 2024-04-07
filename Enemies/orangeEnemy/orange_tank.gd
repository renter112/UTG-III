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
	
	
func _process(_delta):
	$RayCast2D.target_position = tank.global_position - global_position
	$turret.rotation = (tank.position - position).angle()
	if $Timer.is_stopped() && $RayCast2D.is_colliding() != true:
		shoot()
		$Timer.start(2.5)

func shoot():
	var b = bullet.instantiate()
	var b2 = bullet.instantiate()
	var b3 = bullet.instantiate()
	get_tree().get_root().get_node("/root/level").add_child(b)
	get_tree().get_root().get_node("/root/level").add_child(b2)
	get_tree().get_root().get_node("/root/level").add_child(b3)
	var theta = PI / 6
	b.transform = $turret/marker_middle.global_transform
	b2.transform = $turret/marker_left.global_transform#.rotated(PI /6)
	b3.transform = $turret/marker_right.global_transform#.rotated(-PI / 6)


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
