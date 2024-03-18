extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet.tscn")
var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	tank =  get_node("../tank_hull")
	$RayCast2D.add_exception(tank)
	movement_target_position = tank.position
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	pass
	
func _process(delta):
	$RayCast2D.target_position = tank.position - position
	$turret.rotation = (tank.position - position).angle()
	if $Timer.is_stopped() && $RayCast2D.is_colliding() != true:
		shoot()
		$Timer.start(2.0)

func shoot():
	var b = bullet.instantiate()
	get_tree().get_root().get_node("/root/level").add_child(b)
	b.transform = $turret/Marker2D.global_transform

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		movement_target_position = tank.position
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()


	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
	#navigation_agent.get_next_path_position()
	#navigation_agent.set_velocity(velocity) 
	#var current_agent_position: Vector2 = global_position
	#var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	#velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	#move_and_slide()

