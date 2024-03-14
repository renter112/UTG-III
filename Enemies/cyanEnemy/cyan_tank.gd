extends CharacterBody2D

var tank
var bullet = preload("res://Items/bullet_ghost.tscn")
var movement_speed: float = 85.0
var movement_target_position: Vector2
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
func _ready():
	tank =  get_node("../tank_hull")
	movement_target_position = position
	pass
	
func _process(delta):
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	call_deferred("actor_setup")
	movement_target_position = tank.position
	$turret.rotation = (tank.position - position).angle()
	if $Timer.is_stopped():
			shoot()
			$Timer.start(3.0)

func shoot():
	var b = bullet.instantiate()
	get_tree().get_root().get_node("/root/level").add_child(b)
	b.transform = $turret/Marker2D.global_transform

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
