extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet.tscn")
var movement_speed: float = 120
var movement_target_position: Vector2

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	tank =  get_node("../tank_hull")
	$RayCast2D.add_exception(tank)
	movement_target_position = tank.position
	pass
	
func _process(delta):
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	call_deferred("actor_setup")
	$RayCast2D.target_position = tank.position - position
	$turret.rotation = (tank.position - position).angle()
	if $Timer.is_stopped() && $RayCast2D.is_colliding() != true:
		movement_target_position = tank.position
		shoot()
		$Timer.start(2.0)

func shoot():
	var b = bullet.instantiate()
	get_tree().get_root().add_child(b)
	b.transform = $turret/Marker2D.global_transform

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	print(navigation_agent.is_navigation_finished())
	if navigation_agent.is_navigation_finished():
		return
	var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
	translate(direction * movement_speed * delta)
	#navigation_agent.get_next_path_position()
	#navigation_agent.set_velocity(velocity) 
	#var current_agent_position: Vector2 = global_position
	#var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	#velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	#move_and_slide()

