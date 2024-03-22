extends CharacterBody2D


var tank
var movement_speed: float = 150
var movement_target_position: Vector2

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	tank =  get_node("../tank_hull")
	nav.target_position = tank.global_position
	pass
	


func _physics_process(delta):
	if nav.distance_to_target() < 30.0:
		nav.target_position = tank.global_position
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * movement_speed, 7*delta)
	move_and_slide()
