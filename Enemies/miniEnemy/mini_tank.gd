extends CharacterBody2D


var tank
var movement_speed: float = 150
var movement_target_position: Vector2
var oneshot = false
@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	tank =  get_node("../tank_hull")
	nav.target_position = tank.global_position
	pass

func _process(_delta):

	if  global_position.distance_to(tank.global_position) < 128 && not oneshot:
		print("soon?")
		oneshot = true
		movement_speed += 20
		$Timer.start(2.0)

func _physics_process(delta):
	if  global_position.distance_to(tank.global_position) < 128:
		nav.target_position = tank.global_position
	elif nav.distance_to_target() < 20.0:
		nav.target_position = tank.global_position
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * movement_speed, 7*delta)
	move_and_slide()


func _on_timer_timeout():
	$explosion.visible = true
	$explosion.monitoring = true
	$explosion.monitorable = true
	print("KABOOM")
	pass # Replace with function body.




func _on_explosion_body_entered(body):
	if body.name == "tank_hull" || body.name == "tank_collision" || body.name == "tank_turret":
		body.visible = false
	elif body.get_node_or_null("turret"):
		body.queue_free()
		Global.enemies -= 1
	queue_free()
	pass # Replace with function body.


func _on_explosion_area_entered(area):
	if area.name != "tank_collision":
		queue_free()
	pass # Replace with function body.
