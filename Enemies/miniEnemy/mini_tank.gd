extends CharacterBody2D



func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		movement_target_position = tank.position
		return
	var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
	$hull.rotation = direction.angle()
	$CollisionShape2D.rotation = direction.angle()
	translate(direction * movement_speed * delta)
