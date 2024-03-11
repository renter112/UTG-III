extends Area2D

var speed = 250

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.name == "tank_hull":
		body.queue_free()
	elif body.name.ends_with("enemy"):
		body.queue_free()
	queue_free()

