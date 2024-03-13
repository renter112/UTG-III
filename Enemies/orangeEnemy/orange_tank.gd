extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet.tscn")
var movement_speed: float = 75.0
var movement_target_position: Vector2

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	tank =  get_node("../tank_hull")
	movement_target_position = position
	$RayCast2D.add_exception(tank)
	pass
	
func _process(delta):
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	call_deferred("actor_setup")
	$turret.rotation = (tank.position - position).angle()
	$RayCast2D.target_position = tank.position - position
	if $Timer.is_stopped() && $RayCast2D.is_colliding() != true:
			movement_target_position = tank.position
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