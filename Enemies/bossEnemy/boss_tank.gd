extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet_big.tscn")
var movement_speed: float = 25.0
var movement_target_position: Vector2
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
func _ready():
	tank =  get_node("../tank_hull")
	movement_target_position = position
	$RayCast2D.add_exception(tank)
	pass
	
func _process(delta):
	$turret.rotation = (tank.position - position).angle()
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	call_deferred("actor_setup")
	$RayCast2D.target_position = tank.position - position
	if $Timer.is_stopped() && $RayCast2D.is_colliding() != true:
			movement_target_position = tank.position
			$turret.rotation = (tank.position - position).angle()
			shoot()
			$Timer.start(1.5)

func shoot():
	var b = bullet.instantiate()
	var b2 = bullet.instantiate()
	get_tree().get_root().get_node("/root/level").add_child(b)
	get_tree().get_root().get_node("/root/level").add_child(b2)
	b.transform = $turret/Marker2D.global_transform
	b2.transform = $turret/leftMarker2D.global_transform

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
